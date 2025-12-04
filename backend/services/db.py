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
        print("Pinged your deployment. You successfully connected to MongoDB!")
        return True
    except Exception as e:
        print(e)
        return False
    

async def close_db():
    global client
    if client:
        client.close()
        print("Closed MongoDB connection")