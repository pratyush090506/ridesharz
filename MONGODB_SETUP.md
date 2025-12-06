# MongoDB Setup Options

## Option 1: MongoDB Atlas (Cloud - Recommended for Testing)

### Steps:
1. Go to https://www.mongodb.com/cloud/atlas/register
2. Create a free account
3. Create a free M0 cluster (Free tier)
4. Click "Connect" on your cluster
5. Create a database user (username/password)
6. Whitelist your IP (or use 0.0.0.0/0 for testing)
7. Get your connection string (looks like):
   ```
   mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/rideshare?retryWrites=true&w=majority
   ```

### Update application.properties:
```properties
spring.data.mongodb.uri=mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/rideshare?retryWrites=true&w=majority
```

---

## Option 2: Docker (Local MongoDB)

### Prerequisites:
- Docker Desktop installed

### Steps:
```bash
# Run MongoDB in Docker
docker run -d \
  --name mongodb \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password123 \
  mongo:7.0

# View logs
docker logs mongodb

# Stop MongoDB
docker stop mongodb

# Start MongoDB again
docker start mongodb
```

### Update application.properties:
```properties
spring.data.mongodb.uri=mongodb://admin:password123@localhost:27017/rideshare?authSource=admin
```

---

## Option 3: Local MongoDB Installation

### Update Command Line Tools:
```bash
# Remove old tools
sudo rm -rf /Library/Developer/CommandLineTools

# Install new tools
sudo xcode-select --install
```

### Then install MongoDB:
```bash
brew install mongodb-community

# Start MongoDB
brew services start mongodb-community

# Stop MongoDB
brew services stop mongodb-community

# Check status
brew services list
```

### Use default connection:
```properties
spring.data.mongodb.uri=mongodb://localhost:27017/rideshare
```

---

## Quick Test (After Setup)

After setting up MongoDB with any option above:

1. Update `src/main/resources/application.properties` with the correct URI
2. Run the application:
   ```bash
   java -jar target/rideshare-1.0.0.jar
   ```
3. Test the API:
   ```bash
   # Register a user
   curl -X POST http://localhost:8081/api/auth/register \
     -H "Content-Type: application/json" \
     -d '{"username":"testuser","password":"password","role":"ROLE_USER"}'
   
   # Login
   curl -X POST http://localhost:8081/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"username":"testuser","password":"password"}'
   ```

---

## Current Status

✅ Application compiles successfully
✅ Application starts on port 8081
❌ MongoDB connection not configured

Choose any option above to complete the setup!
