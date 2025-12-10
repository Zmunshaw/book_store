from fastapi import APIRouter
from backend.services.openbook import OpenBookAPI

router = APIRouter()
api = OpenBookAPI()

@router.get("/{book_name}")
def search_book(book_name: str, page: int = 1):
    """
    Returns a list of books that match the search query. No auth required.

    Response Format:
    {
        "count": <int>,               # total results found
        "results": [
            {
                "bID": <string>,      # OpenLibrary Work ID, e.g. "OL27513W"
                "title": <string>,
                "sypnosis": <string>, # always empty for now
                "date": <int|null>,   # publish year
                "authorF": <string>,  # first name / first token
                "authorL": <string>,  # last name / last token
                "genre": <string>,    # may be empty
                "image": <string>     # URL to large cover image, or "" if unavailable
            },
            etc etc
        ]
    }

    Query Parameters:
        page (int) — Pagination index (1-based).

    Notes:
        - If no books are found, "results" will be an empty list.
        - If OpenLibrary rate limits or returns invalid data,
          this endpoint will return an empty list and count=0.
    """
    return api.search(book_name, page)