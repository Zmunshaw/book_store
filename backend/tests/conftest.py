import pytest
import asyncio
from typing import AsyncGenerator
from httpx import AsyncClient
from motor.motor_asyncio import AsyncIOMotorClient
from pymongo.server_api import ServerApi
from backend.main import app
from backend.services import db


@pytest.fixture(scope="session")
def event_loop():
    """Create an instance of the default event loop for each test case."""
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()


@pytest.fixture(scope="function")
async def test_db():
    """Create a test database connection"""
    # Use a test database instead of production
    test_uri = "mongodb+srv://admin1:TeOjuosfnsgoy5dO@cluster0.ngbekxz.mongodb.net/?appName=Cluster0"

    client = AsyncIOMotorClient(test_uri, server_api=ServerApi('1'))
    test_database = client.bookstore_test

    # Store original database
    original_db = db.database

    # Replace with test database
    db.database = test_database
    db.client = client

    yield test_database

    # Cleanup: Drop test database and restore original
    await client.drop_database("bookstore_test")
    db.database = original_db
    client.close()


@pytest.fixture(scope="function")
async def async_client(test_db) -> AsyncGenerator[AsyncClient, None]:
    """Create an async HTTP client for testing"""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        yield ac


@pytest.fixture
async def test_user(test_db):
    """Create a test user for authentication tests"""
    from backend.auth import hash_password
    from datetime import date

    users_collection = test_db.users

    user_doc = {
        "fName": "Test",
        "lName": "User",
        "dob": date(1990, 1, 1).isoformat(),
        "uName": "testuser",
        "uPass": hash_password("testpass123")
    }

    result = await users_collection.insert_one(user_doc)
    user_doc["_id"] = result.inserted_id

    return user_doc


@pytest.fixture
async def auth_token(async_client, test_user):
    """Get authentication token for test user"""
    response = await async_client.post(
        "/user/login",
        json={"uName": "testuser", "uPass": "testpass123"}
    )
    assert response.status_code == 200
    return response.json()["access_token"]


@pytest.fixture
async def auth_headers(auth_token):
    """Get authentication headers with token"""
    return {"Authorization": f"Bearer {auth_token}"}
