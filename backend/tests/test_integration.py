import pytest


@pytest.mark.asyncio
class TestIntegrationFlow:
    """Integration tests for complete user workflows"""

    async def test_complete_user_flow(self, async_client, test_db):
        """Test complete user registration, login, and collection workflow"""
        # 1. Register a new user
        user_data = {
            "fName": "Integration",
            "lName": "Test",
            "dob": "1992-03-15",
            "uName": "integrationuser",
            "uPass": "securepass123"
        }
        response = await async_client.post("/user/create", json=user_data)
        assert response.status_code == 201
        user_id = response.json()["uID"]

        # 2. Login with the new user
        login_data = {
            "uName": "integrationuser",
            "uPass": "securepass123"
        }
        response = await async_client.post("/user/login", json=login_data)
        assert response.status_code == 200
        token = response.json()["access_token"]
        headers = {"Authorization": f"Bearer {token}"}

        # 3. Create a collection
        collection_data = {
            "name": "My Reading List",
            "image": "http://example.com/reading.jpg"
        }
        response = await async_client.post(
            "/collections/",
            json=collection_data,
            headers=headers
        )
        assert response.status_code == 201
        collection_id = response.json()["cID"]

        # 4. Add a book to the collection
        book_data = {
            "bID": "OL27448W",
            "title": "The Hobbit",
            "authorF": "J.R.R.",
            "authorL": "Tolkien",
            "date": 1937,
            "genre": "Fantasy",
            "image": "http://example.com/hobbit.jpg"
        }
        response = await async_client.post(
            f"/collections/{collection_id}/books",
            json=book_data,
            headers=headers
        )
        assert response.status_code == 200
        assert len(response.json()["books"]) == 1

        # 5. Get user's collections
        response = await async_client.get("/collections/", headers=headers)
        assert response.status_code == 200
        collections = response.json()
        assert len(collections) == 1
        assert collections[0]["name"] == "My Reading List"
        assert len(collections[0]["books"]) == 1

        # 6. Add another book
        book_data_2 = {
            "bID": "OL27479W",
            "title": "The Lord of the Rings",
            "authorF": "J.R.R.",
            "authorL": "Tolkien",
            "date": 1954,
            "genre": "Fantasy",
            "image": ""
        }
        response = await async_client.post(
            f"/collections/{collection_id}/books",
            json=book_data_2,
            headers=headers
        )
        assert response.status_code == 200
        assert len(response.json()["books"]) == 2

        # 7. Remove first book
        response = await async_client.delete(
            f"/collections/{collection_id}/books/OL27448W",
            headers=headers
        )
        assert response.status_code == 200

        # 8. Verify only one book remains
        response = await async_client.get("/collections/", headers=headers)
        collections = response.json()
        assert len(collections[0]["books"]) == 1
        assert collections[0]["books"][0]["title"] == "The Lord of the Rings"

        # 9. Delete the collection
        response = await async_client.delete(
            f"/collections/{collection_id}",
            headers=headers
        )
        assert response.status_code == 200

        # 10. Verify collection is gone
        response = await async_client.get("/collections/", headers=headers)
        assert len(response.json()) == 0

    async def test_multiple_users_isolation(self, async_client, test_db):
        """Test that users can't access each other's collections"""
        # Create user 1
        user1_data = {
            "fName": "User",
            "lName": "One",
            "dob": "1990-01-01",
            "uName": "user1",
            "uPass": "password123"
        }
        await async_client.post("/user/create", json=user1_data)
        response = await async_client.post("/user/login", json={"uName": "user1", "uPass": "password123"})
        token1 = response.json()["access_token"]
        headers1 = {"Authorization": f"Bearer {token1}"}

        # Create user 2
        user2_data = {
            "fName": "User",
            "lName": "Two",
            "dob": "1991-02-02",
            "uName": "user2",
            "uPass": "password456"
        }
        await async_client.post("/user/create", json=user2_data)
        response = await async_client.post("/user/login", json={"uName": "user2", "uPass": "password456"})
        token2 = response.json()["access_token"]
        headers2 = {"Authorization": f"Bearer {token2}"}

        # User 1 creates a collection
        response = await async_client.post(
            "/collections/",
            json={"name": "User 1 Collection"},
            headers=headers1
        )
        collection1_id = response.json()["cID"]

        # User 2 creates a collection
        response = await async_client.post(
            "/collections/",
            json={"name": "User 2 Collection"},
            headers=headers2
        )
        collection2_id = response.json()["cID"]

        # User 1 should only see their collection
        response = await async_client.get("/collections/", headers=headers1)
        collections = response.json()
        assert len(collections) == 1
        assert collections[0]["name"] == "User 1 Collection"

        # User 2 should only see their collection
        response = await async_client.get("/collections/", headers=headers2)
        collections = response.json()
        assert len(collections) == 1
        assert collections[0]["name"] == "User 2 Collection"

        # User 1 cannot delete User 2's collection
        response = await async_client.delete(
            f"/collections/{collection2_id}",
            headers=headers1
        )
        assert response.status_code == 403

        # User 2 cannot add book to User 1's collection
        book = {
            "bID": "OL123W",
            "title": "Test",
            "authorF": "Test",
            "authorL": "Author"
        }
        response = await async_client.post(
            f"/collections/{collection1_id}/books",
            json=book,
            headers=headers2
        )
        assert response.status_code == 403

    async def test_book_search_integration(self, async_client):
        """Test book search integration (no auth required)"""
        from unittest.mock import patch, Mock

        # Mock the OpenLibrary API response
        with patch('backend.routes.books.api.search') as mock_search:
            mock_search.return_value = {
                "count": 3,
                "results": [
                    {
                        "bID": "OL123W",
                        "title": "Test Book 1",
                        "sypnosis": "",
                        "date": 2020,
                        "authorF": "Author",
                        "authorL": "One",
                        "genre": "Fiction",
                        "image": ""
                    },
                    {
                        "bID": "OL456W",
                        "title": "Test Book 2",
                        "sypnosis": "",
                        "date": 2021,
                        "authorF": "Author",
                        "authorL": "Two",
                        "genre": "Non-fiction",
                        "image": ""
                    },
                    {
                        "bID": "OL789W",
                        "title": "Test Book 3",
                        "sypnosis": "",
                        "date": 2022,
                        "authorF": "Author",
                        "authorL": "Three",
                        "genre": "Science",
                        "image": ""
                    }
                ]
            }

            # Search should work without authentication
            response = await async_client.get("/books/test")
            assert response.status_code == 200
            data = response.json()
            assert data["count"] == 3
            assert len(data["results"]) == 3

            # Test pagination
            response = await async_client.get("/books/test?page=2")
            assert response.status_code == 200

    async def test_authorization_enforcement(self, async_client, test_user, auth_headers):
        """Test that protected routes require authentication"""
        # These should fail without auth
        protected_routes = [
            ("POST", "/collections/", {"name": "Test"}),
            ("GET", "/collections/", None),
        ]

        for method, path, json_data in protected_routes:
            if method == "POST":
                response = await async_client.post(path, json=json_data)
            else:
                response = await async_client.get(path)

            assert response.status_code in [401, 403], f"{method} {path} should require auth"

        # These should succeed with auth
        response = await async_client.post(
            "/collections/",
            json={"name": "Authorized Collection"},
            headers=auth_headers
        )
        assert response.status_code == 201

        response = await async_client.get("/collections/", headers=auth_headers)
        assert response.status_code == 200

    async def test_error_handling_chain(self, async_client, auth_headers, test_db, test_user):
        """Test error handling across multiple operations"""
        # Create collection
        response = await async_client.post(
            "/collections/",
            json={"name": "Error Test Collection"},
            headers=auth_headers
        )
        collection_id = response.json()["cID"]

        # Add book
        book = {
            "bID": "OL999W",
            "title": "Error Test Book",
            "authorF": "Error",
            "authorL": "Test"
        }
        response = await async_client.post(
            f"/collections/{collection_id}/books",
            json=book,
            headers=auth_headers
        )
        assert response.status_code == 200

        # Try to add same book again (should fail)
        response = await async_client.post(
            f"/collections/{collection_id}/books",
            json=book,
            headers=auth_headers
        )
        assert response.status_code == 409

        # Collection should still exist with one book
        response = await async_client.get("/collections/", headers=auth_headers)
        collections = response.json()
        assert len(collections) == 1
        assert len(collections[0]["books"]) == 1

        # Try to remove non-existent book (should succeed without error)
        response = await async_client.delete(
            f"/collections/{collection_id}/books/NONEXISTENT",
            headers=auth_headers
        )
        assert response.status_code == 200

        # Original book should still be there
        response = await async_client.get("/collections/", headers=auth_headers)
        collections = response.json()
        assert len(collections[0]["books"]) == 1
