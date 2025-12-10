import pytest
from datetime import date
from pydantic import ValidationError
from backend.models import (
    UserCreate, UserResponse, UserLogin, Token,
    BookInCollection, CollectionCreate, CollectionResponse,
    AddBookToCollection
)


class TestUserModels:
    """Test user-related Pydantic models"""

    def test_user_create_valid(self):
        """Test creating a valid user"""
        user = UserCreate(
            fName="John",
            lName="Doe",
            dob=date(1990, 1, 1),
            uName="johndoe",
            uPass="password123"
        )
        assert user.fName == "John"
        assert user.lName == "Doe"
        assert user.uName == "johndoe"
        assert user.uPass == "password123"

    def test_user_create_min_length_validation(self):
        """Test that username has minimum length"""
        with pytest.raises(ValidationError):
            UserCreate(
                fName="John",
                lName="Doe",
                dob=date(1990, 1, 1),
                uName="ab",  # Too short
                uPass="password123"
            )

    def test_user_create_password_min_length(self):
        """Test that password has minimum length"""
        with pytest.raises(ValidationError):
            UserCreate(
                fName="John",
                lName="Doe",
                dob=date(1990, 1, 1),
                uName="johndoe",
                uPass="12345"  # Too short
            )

    def test_user_create_missing_fields(self):
        """Test that required fields are enforced"""
        with pytest.raises(ValidationError):
            UserCreate(
                fName="John",
                lName="Doe",
                uName="johndoe"
                # Missing dob and uPass
            )

    def test_user_response_model(self):
        """Test UserResponse model"""
        user = UserResponse(
            uID="123456",
            fName="John",
            lName="Doe",
            dob=date(1990, 1, 1),
            uName="johndoe"
        )
        assert user.uID == "123456"
        assert user.fName == "John"

    def test_user_login_model(self):
        """Test UserLogin model"""
        login = UserLogin(uName="johndoe", uPass="password123")
        assert login.uName == "johndoe"
        assert login.uPass == "password123"

    def test_token_model(self):
        """Test Token model with default token_type"""
        token = Token(access_token="eyJ0eXAiOiJKV1QiLCJhbGc...")
        assert token.access_token == "eyJ0eXAiOiJKV1QiLCJhbGc..."
        assert token.token_type == "bearer"

    def test_token_model_custom_type(self):
        """Test Token model with custom token_type"""
        token = Token(access_token="abc123", token_type="custom")
        assert token.token_type == "custom"


class TestBookModels:
    """Test book-related Pydantic models"""

    def test_book_in_collection_valid(self):
        """Test valid BookInCollection model"""
        book = BookInCollection(
            bID="OL123W",
            title="The Great Gatsby",
            authorF="F. Scott",
            authorL="Fitzgerald",
            date=1925,
            genre="Fiction",
            image="http://example.com/cover.jpg"
        )
        assert book.bID == "OL123W"
        assert book.title == "The Great Gatsby"
        assert book.date == 1925

    def test_book_in_collection_optional_fields(self):
        """Test BookInCollection with optional fields as defaults"""
        book = BookInCollection(
            bID="OL123W",
            title="The Great Gatsby",
            authorF="F. Scott",
            authorL="Fitzgerald"
        )
        assert book.date is None
        assert book.genre == ""
        assert book.image == ""

    def test_add_book_to_collection_model(self):
        """Test AddBookToCollection model"""
        book = AddBookToCollection(
            bID="OL456W",
            title="1984",
            authorF="George",
            authorL="Orwell",
            date=1949,
            genre="Dystopian",
            image="http://example.com/1984.jpg"
        )
        assert book.bID == "OL456W"
        assert book.title == "1984"


class TestCollectionModels:
    """Test collection-related Pydantic models"""

    def test_collection_create_valid(self):
        """Test valid CollectionCreate model"""
        collection = CollectionCreate(
            name="My Favorites",
            image="http://example.com/image.jpg"
        )
        assert collection.name == "My Favorites"
        assert collection.image == "http://example.com/image.jpg"

    def test_collection_create_optional_image(self):
        """Test CollectionCreate with optional image"""
        collection = CollectionCreate(name="Science Fiction")
        assert collection.name == "Science Fiction"
        assert collection.image == ""

    def test_collection_create_name_validation(self):
        """Test that collection name has minimum length"""
        with pytest.raises(ValidationError):
            CollectionCreate(name="")  # Empty name

    def test_collection_response_model(self):
        """Test CollectionResponse model"""
        book1 = BookInCollection(
            bID="OL123W",
            title="Book 1",
            authorF="Author",
            authorL="One"
        )
        book2 = BookInCollection(
            bID="OL456W",
            title="Book 2",
            authorF="Author",
            authorL="Two"
        )

        collection = CollectionResponse(
            cID="col123",
            name="My Collection",
            image="http://example.com/col.jpg",
            books=[book1, book2],
            uID="user123"
        )

        assert collection.cID == "col123"
        assert collection.name == "My Collection"
        assert len(collection.books) == 2
        assert collection.uID == "user123"

    def test_collection_response_empty_books(self):
        """Test CollectionResponse with no books"""
        collection = CollectionResponse(
            cID="col123",
            name="Empty Collection",
            image="",
            uID="user123"
        )
        assert len(collection.books) == 0
