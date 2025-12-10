# Backend Tests

This directory contains comprehensive tests for the BookStore backend API.

## Test Structure

```
tests/
├── __init__.py              # Test package initialization
├── conftest.py              # Pytest fixtures and configuration
├── test_models.py           # Pydantic model validation tests
├── test_auth.py             # Authentication and JWT tests
├── test_services.py         # Service layer tests (DB, OpenBook API, Utils)
├── test_routes_user.py      # User registration and login endpoint tests
├── test_routes_books.py     # Book search endpoint tests
├── test_routes_collections.py # Collection management endpoint tests
├── test_integration.py      # End-to-end integration tests
└── README.md               # This file
```

## Running Tests

### Install test dependencies

```bash
pip install -r requirements-test.txt
```

### Run all tests

```bash
pytest
```

### Run specific test file

```bash
pytest tests/test_models.py
```

### Run specific test class or function

```bash
pytest tests/test_auth.py::TestPasswordHashing::test_hash_password
```

### Run with coverage report

```bash
pytest --cov=backend --cov-report=html
```

The coverage report will be generated in `htmlcov/index.html`.

### Run only unit tests (fast)

```bash
pytest -m unit
```

### Run only integration tests

```bash
pytest -m integration
```

### Run tests in parallel (faster)

```bash
pip install pytest-xdist
pytest -n auto
```

## Test Categories

### Unit Tests

- **test_models.py**: Tests Pydantic model validation, field requirements, and data serialization
- **test_auth.py**: Tests password hashing, JWT token creation/validation, and user authentication
- **test_services.py**: Tests utility functions and OpenLibrary API integration with mocked responses

### Route Tests

- **test_routes_user.py**: Tests user registration, login, password hashing, and authentication
- **test_routes_books.py**: Tests book search functionality, pagination, and query handling
- **test_routes_collections.py**: Tests collection CRUD operations, book management, and authorization

### Integration Tests

- **test_integration.py**: Tests complete user workflows including:
  - User registration → login → collection creation → book management
  - Multi-user isolation
  - Authorization enforcement
  - Error handling chains

## Test Fixtures

Defined in `conftest.py`:

- `test_db`: Creates a temporary test database for each test
- `async_client`: Provides an async HTTP client for API testing
- `test_user`: Creates a test user in the database
- `auth_token`: Provides a valid JWT token for authenticated requests
- `auth_headers`: Provides authorization headers with the JWT token

## Writing New Tests

### Example unit test

```python
def test_my_function():
    result = my_function("input")
    assert result == "expected_output"
```

### Example async route test

```python
@pytest.mark.asyncio
async def test_my_endpoint(async_client, auth_headers):
    response = await async_client.get("/my-endpoint", headers=auth_headers)
    assert response.status_code == 200
    assert response.json()["key"] == "value"
```

### Example test with database

```python
@pytest.mark.asyncio
async def test_database_operation(test_db, test_user):
    collection = test_db.my_collection
    result = await collection.insert_one({"data": "test"})
    assert result.inserted_id is not None
```

## Continuous Integration

These tests can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
- name: Run tests
  run: |
    pip install -r requirements-test.txt
    pytest --cov=backend --cov-report=xml

- name: Upload coverage
  uses: codecov/codecov-action@v3
  with:
    file: ./coverage.xml
```

## Test Coverage Goals

- Minimum coverage: 70%
- Target coverage: 85%+
- Critical paths (auth, user data) should have 95%+ coverage

## Notes

- Tests use a separate test database (`bookstore_test`) that is created and destroyed for each test
- External API calls (OpenLibrary) are mocked to ensure tests are fast and reliable
- Authentication is tested using real JWT tokens but with test users
- All async code is tested using pytest-asyncio

## Troubleshooting

### Database connection issues

Ensure MongoDB is accessible and credentials in `conftest.py` are correct.

### Import errors

Make sure you're running tests from the backend directory:

```bash
cd backend
pytest
```

### Async test failures

Ensure `pytest-asyncio` is installed and tests are marked with `@pytest.mark.asyncio`.
