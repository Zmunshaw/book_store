from fastapi import APIRouter, HTTPException, status, Depends
from backend.auth import create_access_token, verify_password, get_current_user, hash_password
from backend.models import Token, UserCreate, UserLogin, UserResponse, PasswordChange
from passlib.context import CryptContext
from backend.services import db  

router = APIRouter()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

@router.post("/create", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(user: UserCreate):
    users_collection = db.database.users  

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
        "dob": user.dob.isoformat(),
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
    users_collection = db.database.users  
    
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

@router.put("/change-password")
async def change_password(
    password_data: PasswordChange,
    current_user: dict = Depends(get_current_user)
):
    users_collection = db.database.users

    user = await users_collection.find_one({"uName": current_user["uName"]})
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )

    if not verify_password(password_data.current_password, user["uPass"]):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Current password is incorrect"
        )

    new_hashed_password = hash_password(password_data.new_password)

    await users_collection.update_one(
        {"uName": current_user["uName"]},
        {"$set": {"uPass": new_hashed_password}}
    )

    return {"message": "Password changed successfully"}

@router.delete("/delete-account")
async def delete_account(current_user: dict = Depends(get_current_user)):
    users_collection = db.database.users
    collections_collection = db.database.collections

    await collections_collection.delete_many({"uID": current_user["uName"]})

    result = await users_collection.delete_one({"uName": current_user["uName"]})

    if result.deleted_count == 0:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )

    return {"message": "Account deleted successfully"}