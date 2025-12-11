from pymongo.server_api import ServerApi
from motor.motor_asyncio import AsyncIOMotorClient

client = None
database = None

async def db_connect():
    global client, database

    uri = "mongodb+srv://admin1:TeOjuosfnsgoy5dO@cluster0.ngbekxz.mongodb.net/?appName=Cluster0"
    client = AsyncIOMotorClient(uri, server_api=ServerApi('1'))
    database = client.bookstore

    try:
        await client.admin.command('ping')
        print("Pinged your deployment. Connection successful.")

        # Shit gets super slow without indexes...
        try:
            await database.search_cache.create_index([("title", 1), ("page", 1)], unique=True)
        except Exception as e:
            if "duplicate key" in str(e).lower():
                print("Nuking duplicate search_cache entries...")
                await database.search_cache.drop_indexes()

                pipeline = [
                    {"$sort": {"_id": -1}},
                    {"$group": {
                        "_id": {"title": "$title", "page": "$page"},
                        "doc_id": {"$first": "$_id"},
                        "data": {"$first": "$data"}
                    }}
                ]
                unique_docs = await database.search_cache.aggregate(pipeline).to_list(None)

                await database.search_cache.delete_many({})
                if unique_docs:
                    await database.search_cache.insert_many([
                        {
                            "title": doc["_id"]["title"],
                            "page": doc["_id"]["page"],
                            "data": doc["data"]
                        }
                        for doc in unique_docs
                    ])
                    
                await database.search_cache.create_index([("title", 1), ("page", 1)], unique=True)
                print("search_cache index created after cleanup")
            else:
                print(f"Warning: Could not create search_cache index: {e}")

        try:
            await database.descriptions.create_index("work_id", unique=True)
        except Exception as e:
            print(f"Warning: Could not create descriptions index: {e}")

        try:
            await database.users.create_index("uName", unique=True)
        except Exception as e:
            print(f"Warning: Could not create users index: {e}")

        try:
            await database.collections.create_index("uID")
        except Exception as e:
            print(f"Warning: Could not create collections index: {e}")

        try:
            await database.image_cache.create_index("cover_id", unique=True)
        except Exception as e:
            print(f"Warning: Could not create image_cache index: {e}")

        print("Database indexes setup completed.")
        return True
    except Exception as e:
        print("DB connection error:", e)
        return False

async def close_db():
    global client
    if client:
        client.close()
        print("Closed MongoDB connection")
