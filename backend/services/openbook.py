from backend.services.util import sanitize_string
from backend.services.image_cache import ImageCacheService
import httpx
import asyncio

class OpenBookAPI:
    def __init__(self, db):
        self._root = "https://openlibrary.org/search.json"
        self.db = db
        self.image_cache = ImageCacheService(db)

    async def search(self, book_title: str, page: int = 1):

        cache_key = {
            "title": book_title.lower(),
            "page": page
        }

        cached = await self.db.search_cache.find_one(cache_key)
        if cached:
            return cached["data"]

        q = sanitize_string(book_title)
        url = f"{self._root}?q={q}&page={page}"
        async with httpx.AsyncClient() as client:
            r = await client.get(url)
            data = r.json()

            docs = data.get("docs", [])

            book_ids = []
            book_data = []

            cover_ids = []
            for doc in docs:
                key = doc.get("key", "")
                bID = key.split("/")[-1]

                title = doc.get("title", "")
                author_name = doc.get("author_name", [""])
                full = author_name[0] if author_name else ""
                parts = full.split()
                authorF = parts[0] if parts else ""
                authorL = parts[-1] if len(parts) > 1 else ""
                date = doc.get("first_publish_year", None)

                genre = ""
                if "subject" in doc and len(doc["subject"]) > 0:
                    genre = doc["subject"][0]

                cover_id = doc.get("cover_i", None)
                cover_ids.append(str(cover_id) if cover_id else None)

                book_ids.append(bID)
                book_data.append({
                    "bID": bID,
                    "title": title or "Unknown Title",
                    "date": date,
                    "authorF": authorF,
                    "authorL": authorL,
                    "genre": genre,
                    "cover_id": cover_id,
                })

            # Batch fetch descriptions and images in parallel for performance
            descriptions_task = asyncio.gather(
                *[self.get_description_cached(bID, self.db) for bID in book_ids],
                return_exceptions=True
            )
            images_task = self.image_cache.batch_cache_images(cover_ids)

            descriptions, image_urls = await asyncio.gather(descriptions_task, images_task)

            # Combine data with descriptions and images before sending
            results = []
            for i, book in enumerate(book_data):
                desc = descriptions[i] if not isinstance(descriptions[i], Exception) else ""
                cover_id = book.pop("cover_id", None)
                image_url = image_urls.get(str(cover_id), "") if cover_id else ""

                book["sypnosis"] = desc or "No Description Available"
                book["image"] = image_url
                results.append(book)

            output = {
                "count": data.get("num_found", 0),
                "results": results
            }

            # Store new data in cache mDB
            await self.db.search_cache.insert_one({
                **cache_key,
                "data": output
            })

            return output

    
    async def get_description(self, work_id: str):
        url = f"https://openlibrary.org/works/{work_id}.json"
        async with httpx.AsyncClient() as client:
            r = await client.get(url)
            data = r.json()

            desc = data.get("description")
            if isinstance(desc, dict):
                return desc.get("value")
            return desc if desc else "No Description Available"

    async def get_description_cached(self, work_id, db):
        cached = await db.descriptions.find_one({"work_id": work_id})
        if cached:
            return cached["description"]

        url = f"https://openlibrary.org/works/{work_id}.json"
        async with httpx.AsyncClient() as client:
            r = await client.get(url)
            data = r.json()

            desc = data.get("description")
            if isinstance(desc, dict):
                desc = desc.get("value")
            if desc is None:
                desc = ""

            await db.descriptions.insert_one({
                "work_id": work_id,
                "description": desc
            })

            return desc