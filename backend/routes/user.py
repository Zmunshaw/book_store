from fastapi import APIRouter, HTTPException, status
from backend.auth import create_access_token, verify_password
from backend.models import Token, UserCreate, UserLogin, UserResponse
from passlib.context import CryptContext

from backend.services import db

router = APIRouter()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

@router.post("/create")
async def create_user(user: UserCreate):
    users_collection = db.users

    existing_user = await users_collection.find_one({"uName": user.uName})
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Username already exists"
        )
    
    hashed_password = pwd_context.hash(user.uPass)

    user_doc = {
        "fName": user.fName,
        "lName": user.lName,
        "dob": user.dob.isoformat(),  # Convert date to string for MongoDB
        "uName": user.uName,
        "uPass": hashed_password
    }

    result = await users_collection.insert_one(user_doc)

    return UserResponse(
        uID=str(result.inserted_id),
        fName=user.fName,
        lName=user.lName,
        dob=user.dob,
        uName=user.uName
    )

@router.post("/login", response_model=Token)
async def login(credentials: UserLogin):
    users_collection = db.users
    
    user = await users_collection.find_one({"uName": credentials.uName})
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password"
        )
    
    if not verify_password(credentials.uPass, user["uPass"]):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password"
        )
    
    access_token = create_access_token(data={"sub": user["uName"]})
    
    return Token(access_token=access_token)