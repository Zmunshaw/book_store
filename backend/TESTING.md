# Backend Automated Testing

## Overview

The backend is configured to automatically run tests every time it launches. This ensures that the application only starts if all tests pass, maintaining code quality and preventing broken deployments.

## How It Works

1. **Startup Script**: The [start-with-tests.sh](start-with-tests.sh) script runs automatically when the backend container starts
2. **Test Execution**: Pytest runs all tests in the `tests/` directory with coverage reporting
3. **Coverage Requirements**: Tests must achieve at least 70% code coverage
4. **Conditional Launch**: The backend server only starts if all tests pass

## Running the Backend

### With Docker Compose (Production)

```bash
# From the infra directory
cd infra
docker-compose up backend
```

The backend will:
1. Run all tests automatically
2. Display test results and coverage report
3. Start the server on port 8000 if tests pass
4. Exit with an error if tests fail

### With Docker Compose (Development)

```bash
# From the infra directory
cd infra
docker-compose --profile dev up backend-dev
```

Development mode includes:
- Auto-reload on code changes
- Tests run on startup
- Mounted volume for live code updates

### Skipping Tests

If you need to skip tests during development:

```bash
# Set environment variable
RUN_TESTS=false docker-compose up backend

# Or modify .env file in infra/
echo "RUN_TESTS=false" >> .env
docker-compose up backend
```

## Running Tests Manually

### Inside Docker Container

```bash
# Enter the running container
docker exec -it bookstore-backend bash

# Run all tests
pytest tests/ -v

# Run specific test file
pytest tests/test_auth.py -v

# Run with coverage
pytest tests/ --cov=backend --cov-report=html
```

### Locally (without Docker)

```bash
# From backend directory
cd backend

# Install dependencies
pip install -r requirements.txt
pip install -r requirements-test.txt

# Run tests
pytest tests/ -v

# Run with coverage
pytest tests/ --cov=backend --cov-report=html --cov-report=term-missing
```

## Test Configuration

Test configuration is defined in [pytest.ini](pytest.ini):

- **Test Discovery**: Finds all `test_*.py` files in `tests/` directory
- **Coverage Threshold**: 70% minimum coverage required
- **Markers**: Tests can be marked as `unit`, `integration`, or `slow`
- **Async Support**: Automatic async test detection

## Test Structure

```
backend/tests/
├── conftest.py              # Shared fixtures and configuration
├── test_auth.py             # Authentication tests
├── test_models.py           # Data model tests
├── test_routes_books.py     # Book routes tests
├── test_routes_collections.py  # Collection routes tests
├── test_routes_user.py      # User routes tests
├── test_services.py         # Service layer tests
└── test_integration.py      # End-to-end integration tests
```

## Continuous Integration

The automated testing setup ensures:

- **Code Quality**: Only code that passes tests gets deployed
- **Early Detection**: Bugs are caught before the server starts
- **Coverage Tracking**: Maintain minimum code coverage standards
- **Fast Feedback**: Developers know immediately if changes break tests

## Troubleshooting

### Tests Fail on Startup

If the backend fails to start due to test failures:

1. Check the container logs:
   ```bash
   docker logs bookstore-backend
   ```

2. Review the test output to identify failing tests

3. Fix the failing tests or code

4. Rebuild and restart:
   ```bash
   docker-compose down
   docker-compose build backend
   docker-compose up backend
   ```

### Coverage Too Low

If tests fail due to insufficient coverage:

1. Run coverage report to see uncovered lines:
   ```bash
   pytest tests/ --cov=backend --cov-report=html
   # Open htmlcov/index.html in browser
   ```

2. Add tests for uncovered code

3. Or temporarily lower the threshold in [pytest.ini](pytest.ini) (not recommended for production)

### Environment Issues

If tests fail due to environment configuration:

- Ensure MongoDB URI is correct in docker-compose.yml
- Check that test database can be accessed
- Verify all environment variables are set

## Best Practices

1. **Write Tests First**: Follow TDD when adding new features
2. **Keep Tests Fast**: Automated startup tests should complete quickly
3. **Use Test Database**: Always use a separate test database
4. **Clean Up**: Fixtures should clean up test data after each test
5. **Mock External Services**: Don't rely on external APIs in tests
6. **Meaningful Assertions**: Test behavior, not implementation details

## Environment Variables

- `RUN_TESTS`: Set to `false` to skip tests on startup (default: `true`)
- `ENVIRONMENT`: Set to `development` for auto-reload mode
- `MONGODB_URI`: Database connection string for tests
- `SECRET_KEY`: JWT secret key for authentication tests
