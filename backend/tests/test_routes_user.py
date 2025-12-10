import pytest
from datetime import date


@pytest.mark.asyncio
class TestUserRoutes:
    """Test user authentication and registration routes"""

    async def test_create_user_success(self, async_client, test_db):
        """Test successful user creation"""
        user_data = {
            "fName": "John",
            "lName": "Doe",
            "dob": "1990-01-01",
            "uName": "johndoe",
            "uPass": "password123"
        }

        response = await async_client.post("/user/create", json=user_data)

        assert response.status_code == 201
        data = response.json()
        assert data["fName"] == "John"
        assert data["lName"] == "Doe"
        assert data["uName"] == "johndoe"
        assert "uID" in data
        assert "uPass" not in data  # Password should not be in response

    async def test_create_user_duplicate_username(self, async_client, test_user):
        """Test creating user with duplicate username"""
        user_data = {
            "fName": "Another",
            "lName": "User",
            "dob": "1995-05-05",
            "uName": "testuser",  # Same as test_user
            "uPass": "password123"
        }

        response = await async_client.post("/user/create", json=user_data)

        assert response.status_code == 409
        assert "already exists" in response.json()["detail"]

    async def test_create_user_invalid_data(self, async_client):
        """Test creating user with invalid data"""
        user_data = {
            "fName": "John",
            "lName": "Doe",
            "dob": "1990-01-01",
            "uName": "ab",  # Too short
            "uPass": "pass"  # Too short
        }

        response = await async_client.post("/user/create", json=user_data)

        assert response.status_code == 422  # Validation error

    async def test_create_user_missing_fields(self, async_client):
        """Test creating user with missing required fields"""
        user_data = {
            "fName": "John",
            "lName": "Doe"
            # Missing dob, uName, uPass
        }

        response = await async_client.post("/user/create", json=user_data)

        assert response.status_code == 422

    async def test_login_success(self, async_client, test_user):
        """Test successful login"""
        login_data = {
            "uName": "testuser",
            "uPass": "testpass123"
        }

        response = await async_client.post("/user/login", json=login_data)

        assert response.status_code == 200
        data = response.json()
        assert "access_token" in data
        assert data["token_type"] == "bearer"
        assert len(data["access_token"]) > 0

    async def test_login_wrong_password(self, async_client, test_user):
        """Test login with wrong password"""
        login_data = {
            "uName": "testuser",
            "uPass": "wrongpassword"
        }

        response = await async_client.post("/user/login", json=login_data)

        assert response.status_code == 401
        assert "Incorrect username or password" in response.json()["detail"]

    async def test_login_nonexistent_user(self, async_client):
        """Test login with nonexistent username"""
        login_data = {
            "uName": "nonexistentuser",
            "uPass": "password123"
        }

        response = await async_client.post("/user/login", json=login_data)

        assert response.status_code == 401
        assert "Incorrect username or password" in response.json()["detail"]

    async def test_login_invalid_data(self, async_client):
        """Test login with invalid data format"""
        login_data = {
            "uName": "testuser"
            # Missing password
        }

        response = await async_client.post("/user/login", json=login_data)

        assert response.status_code == 422

    async def test_password_is_hashed(self, async_client, test_db):
        """Test that password is hashed in database"""
        user_data = {
            "fName": "Hash",
            "lName": "Test",
            "dob": "1990-01-01",
            "uName": "hashtest",
            "uPass": "mypassword123"
        }

        await async_client.post("/user/create", json=user_data)

        # Check database
        users_col = test_db.users
        user = await users_col.find_one({"uName": "hashtest"})

        assert user is not None
        assert user["uPass"] != "mypassword123"  # Should be hashed
        assert user["uPass"].startswith("$2b$")  # bcrypt hash
