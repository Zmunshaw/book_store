import pytest
from unittest.mock import patch, Mock


@pytest.mark.asyncio
class TestBooksRoutes:
    """Test book search routes"""

    @patch('backend.routes.books.api.search')
    async def test_search_books_success(self, mock_search, async_client):
        """Test successful book search"""
        mock_search.return_value = {
            "count": 2,
            "results": [
                {
                    "bID": "OL123W",
                    "title": "The Great Gatsby",
                    "sypnosis": "",
                    "date": 1925,
                    "authorF": "F. Scott",
                    "authorL": "Fitzgerald",
                    "genre": "Fiction",
                    "image": "http://covers.openlibrary.org/b/id/12345-L.jpg"
                },
                {
                    "bID": "OL456W",
                    "title": "Gatsby's Adventure",
                    "sypnosis": "",
                    "date": 2020,
                    "authorF": "John",
                    "authorL": "Smith",
                    "genre": "Adventure",
                    "image": ""
                }
            ]
        }

        response = await async_client.get("/books/gatsby")

        assert response.status_code == 200
        data = response.json()
        assert data["count"] == 2
        assert len(data["results"]) == 2
        assert data["results"][0]["title"] == "The Great Gatsby"

        # Verify search was called with correct parameters
        mock_search.assert_called_once_with("gatsby", 1)

    @patch('backend.routes.books.api.search')
    async def test_search_books_with_pagination(self, mock_search, async_client):
        """Test book search with pagination"""
        mock_search.return_value = {
            "count": 100,
            "results": []
        }

        response = await async_client.get("/books/gatsby?page=3")

        assert response.status_code == 200

        # Verify search was called with page parameter
        mock_search.assert_called_once_with("gatsby", 3)

    @patch('backend.routes.books.api.search')
    async def test_search_books_no_results(self, mock_search, async_client):
        """Test book search with no results"""
        mock_search.return_value = {
            "count": 0,
            "results": []
        }

        response = await async_client.get("/books/nonexistentbook12345xyz")

        assert response.status_code == 200
        data = response.json()
        assert data["count"] == 0
        assert len(data["results"]) == 0

    @patch('backend.routes.books.api.search')
    async def test_search_books_special_characters(self, mock_search, async_client):
        """Test book search with special characters in query"""
        mock_search.return_value = {
            "count": 0,
            "results": []
        }

        # URL encoding should handle special characters
        response = await async_client.get("/books/the%20great%20gatsby")

        assert response.status_code == 200

    @patch('backend.routes.books.api.search')
    async def test_search_books_default_page(self, mock_search, async_client):
        """Test that default page is 1"""
        mock_search.return_value = {
            "count": 0,
            "results": []
        }

        response = await async_client.get("/books/test")

        assert response.status_code == 200

        # Should use page=1 as default
        mock_search.assert_called_once_with("test", 1)

    @patch('backend.routes.books.api.search')
    async def test_search_books_result_structure(self, mock_search, async_client):
        """Test that book result has correct structure"""
        mock_search.return_value = {
            "count": 1,
            "results": [
                {
                    "bID": "OL123W",
                    "title": "Test Book",
                    "sypnosis": "",
                    "date": 2020,
                    "authorF": "Test",
                    "authorL": "Author",
                    "genre": "Fiction",
                    "image": "http://example.com/image.jpg"
                }
            ]
        }

        response = await async_client.get("/books/test")

        assert response.status_code == 200
        data = response.json()
        book = data["results"][0]

        # Verify all expected fields are present
        assert "bID" in book
        assert "title" in book
        assert "sypnosis" in book
        assert "date" in book
        assert "authorF" in book
        assert "authorL" in book
        assert "genre" in book
        assert "image" in book

    async def test_search_books_no_auth_required(self, async_client):
        """Test that book search doesn't require authentication"""
        # Should work without auth headers
        with patch('backend.routes.books.api.search') as mock_search:
            mock_search.return_value = {"count": 0, "results": []}

            response = await async_client.get("/books/test")

            assert response.status_code == 200
            # No 401 Unauthorized
