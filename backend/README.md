# Book Store Python Backend

FastAPI-based REST API for a book store application with user authentication, book search via OpenLibrary API, and personal collection management.

## Tech Stack

- **Framework**: FastAPI
- **Database**: MongoDB Atlas
- **Authentication**: JWT tokens 
- **Password Hashing**: bcrypt 
- **External API**: OpenLibrary

---

## Setup Instructions

### Prerequisites
- Python 3.11+
- MongoDB Atlas account (cluster already configured)

### Installation

1. **Clone and navigate to backend directory:**
```bash
cd backend
```

2. **Create virtual environment:**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies:**
```bash
pip install -r requirements.txt
```

4. **Run the server:**
```bash
# From parent directory (book_store/)
uvicorn backend.main:app --reload
```

Server runs at: `http://127.0.0.1:8000`

### API Documentation

Interactive docs available at: `http://127.0.0.1:8000/docs`

---

## API Endpoints

### Public Endpoints (No Authentication)

#### 1. Search Books
```http
GET /books/{book_name}?page=1
```

**Response:**
```json
{
  "count": 100,
  "results": [
    {
      "bID": "OL27448W",
      "title": "The Lord of the Rings",
      "sypnosis": "",
      "date": 1954,
      "authorF": "J.R.R.",
      "authorL": "Tolkien",
      "genre": "Fantasy",
      "image": "https://covers.openlibrary.org/b/id/8739161-L.jpg"
    }
  ]
}
```

**Notes:**
- `bID` is OpenLibrary Work ID (required for adding to collections)
- Some fields may be empty strings if not available from OpenLibrary
- `date` can be `null`

#### 2. User Registration
```http
POST /user/create
```

**Request Body:**
```json
{
  "fName": "John",
  "lName": "Doe",
  "dob": "1999-05-15",
  "uName": "johndoe",
  "uPass": "password123"
}
```

**Response:**
```json
{
  "uID": "693737ba2b6a78cc447c09af",
  "fName": "John",
  "lName": "Doe",
  "dob": "1999-05-15",
  "uName": "johndoe"
}
```

**Validation:**
- `fName`, `lName`: 1-50 characters
- `uName`: 3-30 characters, must be unique
- `uPass`: Minimum 6 characters
- `dob`: Format YYYY-MM-DD

#### 3. User Login
```http
POST /user/login
```

**Request Body:**
```json
{
  "uName": "johndoe",
  "uPass": "password123"
}
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer"
}
```

**Important:** Save the `access_token` because it is used for protected endpoints (collectionss).

---

### Protected Endpoints (Require Authentication)

**All requests below must include:**
```http
Authorization: Bearer <access_token>
```

#### 4. Create Collection
```http
POST /collections
```

**Request Body:**
```json
{
  "name": "My Favorites",
  "image": "https://example.com/cover.jpg"
}
```

**Response:**
```json
{
  "cID": "693738ba2b6a78cc447c09b0",
  "name": "My Favorites",
  "image": "https://example.com/cover.jpg",
  "books": [],
  "uID": "693737ba2b6a78cc447c09af"
}
```

#### 5. Get User's Collections
```http
GET /collections
```

**Response:**
```json
[
  {
    "cID": "693738ba2b6a78cc447c09b0",
    "name": "My Favorites",
    "image": "https://example.com/cover.jpg",
    "books": [
      {
        "bID": "OL27448W",
        "title": "The Lord of the Rings",
        "authorF": "J.R.R.",
        "authorL": "Tolkien",
        "date": 1954,
        "genre": "Fantasy",
        "image": "https://covers.openlibrary.org/b/id/8739161-L.jpg"
      }
    ],
    "uID": "693737ba2b6a78cc447c09af"
  }
]
```

#### 6. Add Book to Collection
```http
POST /collections/{cID}/books
```

**Request Body:**
```json
{
  "bID": "OL27448W",
  "title": "The Lord of the Rings",
  "authorF": "J.R.R.",
  "authorL": "Tolkien",
  "date": 1954,
  "genre": "Fantasy",
  "image": "https://covers.openlibrary.org/b/id/8739161-L.jpg"
}
```

**Response:** Returns the updated collection with the new book added.

**Notes:**
- Only `bID` is required
- Returns 409 Conflict if book already exists in collection

#### 7. Remove Book from Collection
```http
DELETE /collections/{cID}/books/{bID}
```

**Response:**
```json
{
  "message": "Book removed successfully"
}
```

#### 8. Delete Collection
```http
DELETE /collections/{cID}
```

**Response:**
```json
{
  "message": "Collection deleted successfully"
}
```

---

## Error Handling

### Status Codes

- `200 OK` - Success
- `201 Created` - Resource created successfully
- `401 Unauthorized` - Invalid or missing token
- `403 Forbidden` - Not authorized to access this resource
- `404 Not Found` - Resource doesn't exist
- `409 Conflict` - Duplicate resource (e.g., username already exists)
- `500 Internal Server Error` - Server error

### Error Response
```json
{
  "detail": "Username already exists"
}
```

## Database Schema

### Users Collection
```json
{
  "_id": ObjectId,
  "fName": "John",
  "lName": "Doe",
  "dob": "1999-05-15",
  "uName": "johndoe",
  "uPass": "$2b$12$..." // Hashed password
}
```

### Collections Collection
```json
{
  "_id": ObjectId,
  "name": "My Favorites",
  "image": "https://...",
  "uID": "user_id_here",
  "books": [
    {
      "bID": "OL27448W",
      "title": "...",
      "authorF": "...",
      "authorL": "...",
      "date": 1954,
      "genre": "...",
      "image": "..."
    }
  ]
}
```

