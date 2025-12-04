from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.routes import books
from backend.services.db import close_db, db_connect

app = FastAPI(title="BookStore API")

@asynccontextmanager
async def lifespan(app: FastAPI):
    # startup
    await db_connect()
    yield
    # shutdown
    await close_db()

# cors config
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Flutter app's URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(books.router, prefix="/books", tags=["Books"])
app.include_router(books.router, prefix="/user", tags=["User"])