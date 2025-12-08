from fastapi import APIRouter, HTTPException, status, Depends
from backend.models import CollectionCreate, CollectionResponse, AddBookToCollection
from backend.services import db
from backend.auth import get_current_user
from typing import List

router = APIRouter()

@router.post("/", response_model=CollectionResponse, status_code=status.HTTP_201_CREATED)
async def create_collection(
    collection: CollectionCreate, 
    current_user: dict = Depends(get_current_user)
):
    collections_col = db.database.collections
    users_col = db.database.users
    
    user = await users_col.find_one({"uName": current_user["uName"]})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    collection_doc = {
        "name": collection.name,
        "image": collection.image,
        "books": [],
        "uID": str(user["_id"])
    }
    
    result = await collections_col.insert_one(collection_doc)
    
    return CollectionResponse(
        cID=str(result.inserted_id),
        name=collection.name,
        image=collection.image,
        books=[],
        uID=str(user["_id"])
    )

@router.get("/", response_model=List[CollectionResponse])
async def get_user_collections(current_user: dict = Depends(get_current_user)):
    collections_col = db.database.collections
    users_col = db.database.users
    
    user = await users_col.find_one({"uName": current_user["uName"]})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    cursor = collections_col.find({"uID": str(user["_id"])})
    collections = await cursor.to_list(length=None)
    
    return [
        CollectionResponse(
            cID=str(col["_id"]),
            name=col["name"],
            image=col.get("image", ""),
            books=col.get("books", []),
            uID=col["uID"]
        )
        for col in collections
    ]

@router.post("/{cID}/books", response_model=CollectionResponse)
async def add_book_to_collection(
    cID: str,
    book: AddBookToCollection,
    current_user: dict = Depends(get_current_user)
):
    """Add a book to a collection"""
    from bson import ObjectId
    
    collections_col = db.database.collections
    users_col = db.database.users
    
    user = await users_col.find_one({"uName": current_user["uName"]})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    collection = await collections_col.find_one({"_id": ObjectId(cID)})
    if not collection:
        raise HTTPException(status_code=404, detail="Collection not found")
    
    if collection["uID"] != str(user["_id"]):
        raise HTTPException(status_code=403, detail="Not authorized")
    
    books = collection.get("books", [])
    if any(b["bID"] == book.bID for b in books):
        raise HTTPException(status_code=409, detail="Book already in collection")
    
    book_dict = book.dict()
    await collections_col.update_one(
        {"_id": ObjectId(cID)},
        {"$push": {"books": book_dict}}
    )
    
    updated = await collections_col.find_one({"_id": ObjectId(cID)})
    return CollectionResponse(
        cID=str(updated["_id"]),
        name=updated["name"],
        image=updated.get("image", ""),
        books=updated.get("books", []),
        uID=updated["uID"]
    )

@router.delete("/{cID}/books/{bID}")
async def remove_book_from_collection(
    cID: str,
    bID: str,
    current_user: dict = Depends(get_current_user)
):
    from bson import ObjectId
    
    collections_col = db.database.collections
    users_col = db.database.users
    
    user = await users_col.find_one({"uName": current_user["uName"]})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    collection = await collections_col.find_one({"_id": ObjectId(cID)})
    if not collection:
        raise HTTPException(status_code=404, detail="Collection not found")
    
    if collection["uID"] != str(user["_id"]):
        raise HTTPException(status_code=403, detail="Not authorized")
    
    # Remove book
    await collections_col.update_one(
        {"_id": ObjectId(cID)},
        {"$pull": {"books": {"bID": bID}}}
    )
    
    return {"message": "Book removed successfully"}

@router.delete("/{cID}")
async def delete_collection(
    cID: str,
    current_user: dict = Depends(get_current_user)
):
    from bson import ObjectId
    
    collections_col = db.database.collections
    users_col = db.database.users
    
    user = await users_col.find_one({"uName": current_user["uName"]})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    collection = await collections_col.find_one({"_id": ObjectId(cID)})
    if not collection:
        raise HTTPException(status_code=404, detail="Collection not found")
    
    if collection["uID"] != str(user["_id"]):
        raise HTTPException(status_code=403, detail="Not authorized")
    
    await collections_col.delete_one({"_id": ObjectId(cID)})
    
    return {"message": "Collection deleted successfully"}