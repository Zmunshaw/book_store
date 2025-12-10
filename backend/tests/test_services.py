import pytest
from unittest.mock import Mock, patch, AsyncMock
from backend.services.util import sanitize_string
from backend.services.openbook import OpenBookAPI


class TestUtilService:
    """Test utility functions"""

    def test_sanitize_string_basic(self):
        """Test basic string sanitization"""
        result = sanitize_string("Hello World")
        assert result == "hello+world"

    def test_sanitize_string_multiple_spaces(self):
        """Test sanitizing string with multiple spaces"""
        result = sanitize_string("the    Lord  of the rings")
        assert result == "the+lord+of+the+rings"

    def test_sanitize_string_leading_trailing_spaces(self):
        """Test sanitizing string with leading/trailing spaces"""
        result = sanitize_string("  hello world  ")
        assert result == "hello+world"

    def test_sanitize_string_uppercase(self):
        """Test that uppercase is converted to lowercase"""
        result = sanitize_string("HELLO WORLD")
        assert result == "hello+world"

    def test_sanitize_string_mixed_case(self):
        """Test sanitizing mixed case string"""
        result = sanitize_string("ThE GrEaT GaTsBY")
        assert result == "the+great+gatsby"

    def test_sanitize_string_single_word(self):
        """Test sanitizing single word"""
        result = sanitize_string("hello")
        assert result == "hello"

    def test_sanitize_string_empty(self):
        """Test sanitizing empty string"""
        result = sanitize_string("")
        assert result == ""

    def test_sanitize_string_only_spaces(self):
        """Test sanitizing string with only spaces"""
        result = sanitize_string("     ")
        assert result == ""


class TestOpenBookAPI:
    """Test OpenLibrary API integration"""

    def test_openbook_api_initialization(self):
        """Test OpenBookAPI initialization"""
        api = OpenBookAPI()
        assert api._root == "https://openlibrary.org/search.json"

    @patch('backend.services.openbook.requests.get')
    def test_search_basic(self, mock_get):
        """Test basic book search"""
        # Mock response
        mock_response = Mock()
        mock_response.json.return_value = {
            "num_found": 1,
            "docs": [
                {
                    "key": "/works/OL123W",
                    "title": "The Great Gatsby",
                    "author_name": ["F. Scott Fitzgerald"],
                    "first_publish_year": 1925,
                    "subject": ["Fiction", "Classic"],
                    "cover_i": 12345
                }
            ]
        }
        mock_get.return_value = mock_response

        api = OpenBookAPI()
        result = api.search("gatsby")

        assert result["count"] == 1
        assert len(result["results"]) == 1

        book = result["results"][0]
        assert book["bID"] == "OL123W"
        assert book["title"] == "The Great Gatsby"
        assert book["authorF"] == "F."
        assert book["authorL"] == "Fitzgerald"
        assert book["date"] == 1925
        assert book["genre"] == "Fiction"
        assert "12345" in book["image"]

    @patch('backend.services.openbook.requests.get')
    def test_search_no_results(self, mock_get):
        """Test search with no results"""
        mock_response = Mock()
        mock_response.json.return_value = {
            "num_found": 0,
            "docs": []
        }
        mock_get.return_value = mock_response

        api = OpenBookAPI()
        result = api.search("nonexistentbook12345xyz")

        assert result["count"] == 0
        assert len(result["results"]) == 0

    @patch('backend.services.openbook.requests.get')
    def test_search_missing_fields(self, mock_get):
        """Test search with missing fields in response"""
        mock_response = Mock()
        mock_response.json.return_value = {
            "num_found": 1,
            "docs": [
                {
                    "key": "/works/OL456W",
                    "title": "Unknown Book"
                    # Missing: author_name, first_publish_year, subject, cover_i
                }
            ]
        }
        mock_get.return_value = mock_response

        api = OpenBookAPI()
        result = api.search("unknown")

        assert result["count"] == 1
        book = result["results"][0]
        assert book["bID"] == "OL456W"
        assert book["title"] == "Unknown Book"
        assert book["authorF"] == ""
        assert book["authorL"] == ""
        assert book["date"] is None
        assert book["genre"] == ""
        assert book["image"] == ""

    @patch('backend.services.openbook.requests.get')
    def test_search_with_pagination(self, mock_get):
        """Test search with pagination"""
        mock_response = Mock()
        mock_response.json.return_value = {
            "num_found": 100,
            "docs": []
        }
        mock_get.return_value = mock_response

        api = OpenBookAPI()
        api.search("gatsby", page=2)

        # Verify the URL includes the page parameter
        mock_get.assert_called_once()
        call_args = mock_get.call_args[0][0]
        assert "page=2" in call_args

    @patch('backend.services.openbook.requests.get')
    def test_search_sanitizes_query(self, mock_get):
        """Test that search query is sanitized"""
        mock_response = Mock()
        mock_response.json.return_value = {
            "num_found": 0,
            "docs": []
        }
        mock_get.return_value = mock_response

        api = OpenBookAPI()
        api.search("The Great  Gatsby")

        # Verify the URL has sanitized query
        mock_get.assert_called_once()
        call_args = mock_get.call_args[0][0]
        assert "the+great+gatsby" in call_args

    @patch('backend.services.openbook.requests.get')
    def test_search_multiple_authors(self, mock_get):
        """Test search with book having multiple authors"""
        mock_response = Mock()
        mock_response.json.return_value = {
            "num_found": 1,
            "docs": [
                {
                    "key": "/works/OL789W",
                    "title": "Multi Author Book",
                    "author_name": ["John Doe", "Jane Smith"],
                    "first_publish_year": 2020
                }
            ]
        }
        mock_get.return_value = mock_response

        api = OpenBookAPI()
        result = api.search("multi")

        book = result["results"][0]
        # Should use first author
        assert book["authorF"] == "John"
        assert book["authorL"] == "Doe"

    @patch('backend.services.openbook.requests.get')
    def test_search_single_name_author(self, mock_get):
        """Test search with author having single name"""
        mock_response = Mock()
        mock_response.json.return_value = {
            "num_found": 1,
            "docs": [
                {
                    "key": "/works/OL999W",
                    "title": "Single Name",
                    "author_name": ["Madonna"]
                }
            ]
        }
        mock_get.return_value = mock_response

        api = OpenBookAPI()
        result = api.search("madonna")

        book = result["results"][0]
        assert book["authorF"] == "Madonna"
        assert book["authorL"] == ""

    @patch('backend.services.openbook.requests.get')
    def test_search_no_cover_image(self, mock_get):
        """Test search when book has no cover image"""
        mock_response = Mock()
        mock_response.json.return_value = {
            "num_found": 1,
            "docs": [
                {
                    "key": "/works/OL111W",
                    "title": "No Cover Book",
                    "author_name": ["Test Author"]
                    # No cover_i field
                }
            ]
        }
        mock_get.return_value = mock_response

        api = OpenBookAPI()
        result = api.search("nocover")

        book = result["results"][0]
        assert book["image"] == ""
