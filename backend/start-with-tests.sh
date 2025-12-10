#!/bin/bash

# Backend startup script with automated testing
# This script runs tests before starting the backend server
# This shit is exclusively AI Gen because why not.

set -e  # Exit on error

echo "========================================="
echo "BookStore Backend - Starting with Tests"
echo "========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we should run tests (can be disabled via environment variable)
RUN_TESTS=${RUN_TESTS:-true}

if [ "$RUN_TESTS" = "true" ]; then
    echo -e "${YELLOW}Running backend tests...${NC}"

    # Run pytest with coverage from backend directory
    cd backend
    if pytest tests/ -v --tb=short --cov=backend --cov-report=term-missing --cov-fail-under=70; then
        echo -e "${GREEN}✓ All tests passed successfully!${NC}"
    else
        echo -e "${RED}✗ Tests failed! Backend will not start.${NC}"
        exit 1
    fi
    cd ..

    echo ""
    echo "========================================="
else
    echo -e "${YELLOW}Skipping tests (RUN_TESTS=false)${NC}"
fi

# Start the backend server
echo -e "${GREEN}Starting backend server...${NC}"
echo "========================================="
echo ""

# Check if running in development mode
if [ "$ENVIRONMENT" = "development" ]; then
    exec uvicorn backend.main:app --host 0.0.0.0 --port 8000 --reload
else
    exec uvicorn backend.main:app --host 0.0.0.0 --port 8000
fi
