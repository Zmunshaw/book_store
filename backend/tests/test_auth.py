import pytest
from datetime import datetime, timedelta
from jose import jwt
from backend.auth import (
    verify_password, hash_password, create_access_token,
    get_current_user, SECRET_KEY, ALGORITHM
)
from fastapi import HTTPException
from fastapi.security import HTTPAuthorizationCredentials


class TestPasswordHashing:
    """Test password hashing and verification"""

    def test_hash_password(self):
        """Test that password is hashed correctly"""
        password = "mypassword123"
        hashed = hash_password(password)

        assert hashed != password
        assert len(hashed) > 0
        assert hashed.startswith("$2b$")  # bcrypt hash prefix

    def test_verify_password_correct(self):
        """Test verifying correct password"""
        password = "mypassword123"
        hashed = hash_password(password)

        assert verify_password(password, hashed) is True

    def test_verify_password_incorrect(self):
        """Test verifying incorrect password"""
        password = "mypassword123"
        wrong_password = "wrongpassword"
        hashed = hash_password(password)

        assert verify_password(wrong_password, hashed) is False

    def test_hash_different_for_same_password(self):
        """Test that same password produces different hashes (salt)"""
        password = "mypassword123"
        hash1 = hash_password(password)
        hash2 = hash_password(password)

        assert hash1 != hash2
        assert verify_password(password, hash1) is True
        assert verify_password(password, hash2) is True


class TestJWTTokens:
    """Test JWT token creation and validation"""

    def test_create_access_token(self):
        """Test creating a JWT access token"""
        data = {"sub": "testuser"}
        token = create_access_token(data)

        assert isinstance(token, str)
        assert len(token) > 0

        # Decode and verify
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        assert payload["sub"] == "testuser"
        assert "exp" in payload

    def test_token_expiration_set(self):
        """Test that token has expiration time"""
        data = {"sub": "testuser"}
        token = create_access_token(data)

        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        exp_timestamp = payload["exp"]
        exp_datetime = datetime.fromtimestamp(exp_timestamp)

        # Should expire in approximately 24 hours
        now = datetime.utcnow()
        time_diff = exp_datetime - now

        # Check it's within 23-25 hours (allowing for test execution time)
        assert 23 * 3600 < time_diff.total_seconds() < 25 * 3600

    def test_token_with_custom_data(self):
        """Test creating token with additional data"""
        data = {"sub": "testuser", "role": "admin", "user_id": "12345"}
        token = create_access_token(data)

        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        assert payload["sub"] == "testuser"
        assert payload["role"] == "admin"
        assert payload["user_id"] == "12345"

    @pytest.mark.asyncio
    async def test_get_current_user_valid_token(self):
        """Test extracting user from valid token"""
        data = {"sub": "testuser"}
        token = create_access_token(data)

        credentials = HTTPAuthorizationCredentials(
            scheme="Bearer",
            credentials=token
        )

        user = await get_current_user(credentials)
        assert user["uName"] == "testuser"

    @pytest.mark.asyncio
    async def test_get_current_user_invalid_token(self):
        """Test that invalid token raises exception"""
        credentials = HTTPAuthorizationCredentials(
            scheme="Bearer",
            credentials="invalid.token.here"
        )

        with pytest.raises(HTTPException) as exc_info:
            await get_current_user(credentials)

        assert exc_info.value.status_code == 401
        assert "Invalid authentication credentials" in exc_info.value.detail

    @pytest.mark.asyncio
    async def test_get_current_user_missing_sub(self):
        """Test that token without 'sub' raises exception"""
        # Create token without 'sub' field
        to_encode = {"user": "testuser"}
        expire = datetime.utcnow() + timedelta(minutes=60)
        to_encode.update({"exp": expire})
        token = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

        credentials = HTTPAuthorizationCredentials(
            scheme="Bearer",
            credentials=token
        )

        with pytest.raises(HTTPException) as exc_info:
            await get_current_user(credentials)

        assert exc_info.value.status_code == 401

    @pytest.mark.asyncio
    async def test_get_current_user_expired_token(self):
        """Test that expired token raises exception"""
        # Create an already-expired token
        to_encode = {"sub": "testuser"}
        expire = datetime.utcnow() - timedelta(minutes=1)  # Expired 1 minute ago
        to_encode.update({"exp": expire})
        token = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

        credentials = HTTPAuthorizationCredentials(
            scheme="Bearer",
            credentials=token
        )

        with pytest.raises(HTTPException) as exc_info:
            await get_current_user(credentials)

        assert exc_info.value.status_code == 401
