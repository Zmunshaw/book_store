from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.routes import books, user, collections 
from backend.services.db import close_db, db_connect


@asynccontextmanager
async def lifespan(app: FastAPI):
    await db_connect()
    yield
    await close_db()

app = FastAPI(title="BookStore API", lifespan=lifespan)

# cors config
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Flutter app's URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(books.router, prefix="/books", tags=["Books"])
app.include_router(user.router, prefix="/user", tags=["User"])
app.include_router(collections.router, prefix="/collections", tags=["Collections"])