// Initialize MongoDB with bookstore database and collections

db = db.getSiblingDB('bookstore');

// Create collections
db.createCollection('users');
db.createCollection('collections');

// Create indexes for better performance
db.users.createIndex({ "uName": 1 }, { unique: true });
db.users.createIndex({ "_id": 1 });

db.collections.createIndex({ "uID": 1 });
db.collections.createIndex({ "_id": 1 });
db.collections.createIndex({ "name": 1 });

// Create a default user (optional - for testing)
// Password is hashed version of "testpass123"
db.users.insertOne({
    "fName": "Test",
    "lName": "User",
    "dob": "1990-01-01",
    "uName": "testuser",
    "uPass": "$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYfQYe0G1Zu"
});

print('MongoDB initialization completed for bookstore database');
