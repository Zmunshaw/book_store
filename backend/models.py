from pydantic import BaseModel, Field
from datetime import date
from typing import List, Optional

class UserCreate(BaseModel):
    fName: str = Field(..., min_length=1, max_length=50, description="First name")
    lName: str = Field(..., min_length=1, max_length=50, description="Last name")
    dob: date = Field(..., description="Date of birth (YYYY-MM-DD)")
    uName: str = Field(..., min_length=3, max_length=30, description="Username")
    uPass: str = Field(..., min_length=6, description="Password")

class UserResponse(BaseModel):
    uID: str
    fName: str
    lName: str
    dob: date
    uName: str

class UserLogin(BaseModel):
    uName: str
    uPass: str

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    

class BookInCollection(BaseModel):
    bID: str
    title: str
    authorF: str
    authorL: str
    date: Optional[int] = None
    genre: str = ""
    image: str = ""

class CollectionCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    image: Optional[str] = ""

class CollectionResponse(BaseModel):
    cID: str
    name: str
    image: str
    books: List[BookInCollection] = []
    uID: str

class AddBookToCollection(BaseModel):
    bID: str
    title: str
    authorF: str
    authorL: str
    date: Optional[int] = None
    genre: str = ""
    image: str = ""