import pytest
from bson import ObjectId


@pytest.mark.asyncio
class TestCollectionsRoutes:
    """Test collection management routes"""

    async def test_create_collection_success(self, async_client, auth_headers):
        """Test successful collection creation"""
        collection_data = {
            "name": "My Favorites",
            "image": "http://example.com/image.jpg"
        }

        response = await async_client.post(
            "/collections/",
            json=collection_data,
            headers=auth_headers
        )

        assert response.status_code == 201
        data = response.json()
        assert data["name"] == "My Favorites"
        assert data["image"] == "http://example.com/image.jpg"
        assert "cID" in data
        assert "uID" in data
        assert data["books"] == []

    async def test_create_collection_without_image(self, async_client, auth_headers):
        """Test creating collection without image"""
        collection_data = {
            "name": "Science Fiction"
        }

        response = await async_client.post(
            "/collections/",
            json=collection_data,
            headers=auth_headers
        )

        assert response.status_code == 201
        data = response.json()
        assert data["name"] == "Science Fiction"
        assert data["image"] == ""

    async def test_create_collection_no_auth(self, async_client):
        """Test creating collection without authentication"""
        collection_data = {
            "name": "My Collection"
        }

        response = await async_client.post(
            "/collections/",
            json=collection_data
        )

        assert response.status_code == 403  # Forbidden or 401 Unauthorized

    async def test_create_collection_invalid_data(self, async_client, auth_headers):
        """Test creating collection with invalid data"""
        collection_data = {
            "name": ""  # Empty name should fail validation
        }

        response = await async_client.post(
            "/collections/",
            json=collection_data,
            headers=auth_headers
        )

        assert response.status_code == 422

    async def test_get_user_collections_empty(self, async_client, auth_headers):
        """Test getting collections when user has none"""
        response = await async_client.get(
            "/collections/",
            headers=auth_headers
        )

        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) == 0

    async def test_get_user_collections(self, async_client, auth_headers, test_db, test_user):
        """Test getting user's collections"""
        # Create some collections
        collections_col = test_db.collections
        await collections_col.insert_many([
            {
                "name": "Collection 1",
                "image": "",
                "books": [],
                "uID": str(test_user["_id"])
            },
            {
                "name": "Collection 2",
                "image": "http://example.com/img.jpg",
                "books": [],
                "uID": str(test_user["_id"])
            }
        ])

        response = await async_client.get(
            "/collections/",
            headers=auth_headers
        )

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["name"] in ["Collection 1", "Collection 2"]

    async def test_get_collections_no_auth(self, async_client):
        """Test getting collections without authentication"""
        response = await async_client.get("/collections/")

        assert response.status_code == 403

    async def test_add_book_to_collection_success(self, async_client, auth_headers, test_db, test_user):
        """Test adding a book to collection"""
        # Create a collection
        collections_col = test_db.collections
        result = await collections_col.insert_one({
            "name": "My Books",
            "image": "",
            "books": [],
            "uID": str(test_user["_id"])
        })
        collection_id = str(result.inserted_id)

        book_data = {
            "bID": "OL123W",
            "title": "The Great Gatsby",
            "authorF": "F. Scott",
            "authorL": "Fitzgerald",
            "date": 1925,
            "genre": "Fiction",
            "image": "http://example.com/gatsby.jpg"
        }

        response = await async_client.post(
            f"/collections/{collection_id}/books",
            json=book_data,
            headers=auth_headers
        )

        assert response.status_code == 200
        data = response.json()
        assert len(data["books"]) == 1
        assert data["books"][0]["title"] == "The Great Gatsby"

    async def test_add_duplicate_book_to_collection(self, async_client, auth_headers, test_db, test_user):
        """Test adding duplicate book to collection"""
        # Create a collection with a book
        collections_col = test_db.collections
        book = {
            "bID": "OL123W",
            "title": "Test Book",
            "authorF": "Test",
            "authorL": "Author",
            "date": 2020,
            "genre": "Fiction",
            "image": ""
        }
        result = await collections_col.insert_one({
            "name": "My Books",
            "image": "",
            "books": [book],
            "uID": str(test_user["_id"])
        })
        collection_id = str(result.inserted_id)

        # Try to add the same book again
        response = await async_client.post(
            f"/collections/{collection_id}/books",
            json=book,
            headers=auth_headers
        )

        assert response.status_code == 409  # Conflict
        assert "already in collection" in response.json()["detail"]

    async def test_add_book_to_nonexistent_collection(self, async_client, auth_headers):
        """Test adding book to non-existent collection"""
        fake_id = str(ObjectId())
        book_data = {
            "bID": "OL123W",
            "title": "Test",
            "authorF": "Test",
            "authorL": "Author"
        }

        response = await async_client.post(
            f"/collections/{fake_id}/books",
            json=book_data,
            headers=auth_headers
        )

        assert response.status_code == 404

    async def test_add_book_unauthorized(self, async_client, auth_headers, test_db):
        """Test adding book to another user's collection"""
        # Create collection for different user
        collections_col = test_db.collections
        result = await collections_col.insert_one({
            "name": "Someone else's collection",
            "image": "",
            "books": [],
            "uID": "different_user_id"
        })
        collection_id = str(result.inserted_id)

        book_data = {
            "bID": "OL123W",
            "title": "Test",
            "authorF": "Test",
            "authorL": "Author"
        }

        response = await async_client.post(
            f"/collections/{collection_id}/books",
            json=book_data,
            headers=auth_headers
        )

        assert response.status_code == 403

    async def test_remove_book_from_collection(self, async_client, auth_headers, test_db, test_user):
        """Test removing a book from collection"""
        # Create collection with a book
        collections_col = test_db.collections
        book = {
            "bID": "OL123W",
            "title": "Test Book",
            "authorF": "Test",
            "authorL": "Author"
        }
        result = await collections_col.insert_one({
            "name": "My Books",
            "image": "",
            "books": [book],
            "uID": str(test_user["_id"])
        })
        collection_id = str(result.inserted_id)

        response = await async_client.delete(
            f"/collections/{collection_id}/books/OL123W",
            headers=auth_headers
        )

        assert response.status_code == 200
        assert "removed successfully" in response.json()["message"]

        # Verify book was removed
        updated = await collections_col.find_one({"_id": result.inserted_id})
        assert len(updated["books"]) == 0

    async def test_remove_book_unauthorized(self, async_client, auth_headers, test_db):
        """Test removing book from another user's collection"""
        collections_col = test_db.collections
        result = await collections_col.insert_one({
            "name": "Someone else's collection",
            "image": "",
            "books": [],
            "uID": "different_user_id"
        })
        collection_id = str(result.inserted_id)

        response = await async_client.delete(
            f"/collections/{collection_id}/books/OL123W",
            headers=auth_headers
        )

        assert response.status_code == 403

    async def test_delete_collection(self, async_client, auth_headers, test_db, test_user):
        """Test deleting a collection"""
        collections_col = test_db.collections
        result = await collections_col.insert_one({
            "name": "To Delete",
            "image": "",
            "books": [],
            "uID": str(test_user["_id"])
        })
        collection_id = str(result.inserted_id)

        response = await async_client.delete(
            f"/collections/{collection_id}",
            headers=auth_headers
        )

        assert response.status_code == 200
        assert "deleted successfully" in response.json()["message"]

        # Verify collection was deleted
        deleted = await collections_col.find_one({"_id": result.inserted_id})
        assert deleted is None

    async def test_delete_collection_unauthorized(self, async_client, auth_headers, test_db):
        """Test deleting another user's collection"""
        collections_col = test_db.collections
        result = await collections_col.insert_one({
            "name": "Someone else's collection",
            "image": "",
            "books": [],
            "uID": "different_user_id"
        })
        collection_id = str(result.inserted_id)

        response = await async_client.delete(
            f"/collections/{collection_id}",
            headers=auth_headers
        )

        assert response.status_code == 403

    async def test_delete_nonexistent_collection(self, async_client, auth_headers):
        """Test deleting non-existent collection"""
        fake_id = str(ObjectId())

        response = await async_client.delete(
            f"/collections/{fake_id}",
            headers=auth_headers
        )

        assert response.status_code == 404
