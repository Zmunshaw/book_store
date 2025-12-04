from util import sanitize_string
import requests

class OpenBookAPI():
    def __init__(self):
        self._root = "https://openlibrary.org/search.json"

    def search(self, book_title: str, page: int = 1):
            q = sanitize_string(book_title)

            url = f"{self._root}?q={q}&page={page}"
            r = requests.get(url)
            data = r.json()

            docs = data.get("docs", [])

            results = []

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
                image = f"https://covers.openlibrary.org/b/id/{cover_id}-L.jpg" if cover_id else ""

                book_obj = {
                    "bID": bID,
                    "title": title,
                    "sypnosis": "", 
                    "date": date,
                    "authorF": authorF,
                    "authorL": authorL,
                    "genre": genre,
                    "image": image,
                }

                results.append(book_obj)

            return {
                "count": data.get("num_found", 0),
                "results": results
            }