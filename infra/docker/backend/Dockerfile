# Multi-stage Docker build for BookStore Backend

# Stage 1: Base image with Python dependencies
FROM python:3.11-slim as base

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set working directory
WORKDIR /app

# Stage 2: Dependencies
FROM base as dependencies

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY backend/requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Stage 3: Production image
FROM base as production

# Install system dependencies needed for tests and runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy Python dependencies from dependencies stage
COPY --from=dependencies /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=dependencies /usr/local/bin /usr/local/bin

# Create non-root user for security
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

# Copy requirements files and install test dependencies (needed for running tests on startup)
COPY backend/requirements.txt backend/requirements-test.txt ./
RUN pip install --no-cache-dir -r requirements-test.txt

# Copy application code - maintain backend package structure
COPY --chown=appuser:appuser backend/ ./backend/

# Copy startup script to root
COPY --chown=appuser:appuser backend/start-with-tests.sh ./start-with-tests.sh

# Make startup script executable
RUN chmod +x start-with-tests.sh

# Set PYTHONPATH to allow imports from backend package
ENV PYTHONPATH=/app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/docs || exit 1

# Run the application with tests
CMD ["./start-with-tests.sh"]

# Stage 4: Development image
FROM production as development

# Development mode already has test dependencies from production stage
# The startup script will handle running tests and starting with --reload

# No need to override CMD - the startup script will check ENVIRONMENT variable
