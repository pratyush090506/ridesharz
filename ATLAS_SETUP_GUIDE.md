# MongoDB Atlas Setup - Complete Walkthrough

## 🎯 Quick Steps Overview
1. Create Atlas account (2 min)
2. Create free cluster (3 min)
3. Get connection string (1 min)
4. Update application.properties (1 min)
5. Run & test! (1 min)

---

## 📋 Detailed Steps

### 1️⃣ Create MongoDB Atlas Account

**Go to:** https://www.mongodb.com/cloud/atlas/register

- Click "Sign Up"
- Use email or Google/GitHub
- Fill in your details
- Verify email if needed

---

### 2️⃣ Create Your Free Cluster

After logging in:

1. **You'll see "Create a deployment" or "Build a Database"**
   - Click it

2. **Choose FREE tier:**
   - Select **"M0"** (shows "FREE")
   - Don't select M2 or M5 (those cost money)

3. **Select provider & region:**
   - Provider: AWS, Google Cloud, or Azure (doesn't matter)
   - Region: Choose closest to your location
     - Example: `us-east-1` for US East Coast
     - Example: `ap-south-1` for India

4. **Cluster Name:**
   - Leave default (`Cluster0`) or name it `rideshare-cluster`

5. **Click "Create Deployment"**
   - Wait 1-3 minutes for cluster to provision

---

### 3️⃣ Create Database User

A popup will appear (or go to **Security → Database Access**):

1. **Authentication Method:**
   - Choose "Password" (default)

2. **Create credentials:**
   ```
   Username: rideshare_user
   Password: [Click "Autogenerate" or create your own]
   ```
   
3. **⚠️ IMPORTANT: Save these credentials!**
   - Copy username: `rideshare_user`
   - Copy password: (whatever was generated/created)

4. **Database User Privileges:**
   - Select "Read and write to any database" (default)

5. **Click "Create Database User"**

---

### 4️⃣ Setup Network Access

The popup continues (or go to **Security → Network Access**):

1. **Choose access method:**
   - Option A: Click "Add My Current IP Address" (safer)
   - Option B: Add IP `0.0.0.0/0` (allows from anywhere - easier for testing)

2. **For testing, use Option B:**
   - Click "Add a Different IP Address"
   - Enter: `0.0.0.0/0`
   - Description: "Allow All (Testing Only)"

3. **Click "Add Entry"** then **"Finish and Close"**

---

### 5️⃣ Get Your Connection String

1. **Go back to your cluster dashboard**
   - Click "Database" in left menu if not there

2. **Click "Connect" button** on your cluster

3. **Choose "Drivers"**

4. **Select:**
   - Driver: **Java**
   - Version: **4.3 or later**

5. **Copy the connection string** (Step 3 on their page)
   - It looks like:
   ```
   mongodb+srv://rideshare_user:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
   ```

6. **Modify the connection string:**
   
   **Original:**
   ```
   mongodb+srv://rideshare_user:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
   ```
   
   **Changes needed:**
   - Replace `<password>` with your actual password
   - Add `/rideshare` before the `?`
   
   **Final string:**
   ```
   mongodb+srv://rideshare_user:YourActualPassword123@cluster0.xxxxx.mongodb.net/rideshare?retryWrites=true&w=majority
   ```

---

### 6️⃣ Update Your Application

1. **Open file:** `src/main/resources/application.properties`

2. **Find this line:**
   ```properties
   spring.data.mongodb.uri=mongodb://localhost:27017/rideshare
   ```

3. **Replace with your Atlas connection string:**
   ```properties
   spring.data.mongodb.uri=mongodb+srv://rideshare_user:YourPassword@cluster0.xxxxx.mongodb.net/rideshare?retryWrites=true&w=majority
   ```

4. **Example (with fake credentials):**
   ```properties
   spring.data.mongodb.uri=mongodb+srv://rideshare_user:MyPass123@cluster0.abc12.mongodb.net/rideshare?retryWrites=true&w=majority
   ```

---

### 7️⃣ Rebuild & Run

```bash
# Rebuild the application
mvn clean package -DskipTests

# Run it
java -jar target/rideshare-1.0.0.jar
```

**Look for this in the logs:**
```
MongoDB client created with settings...
Tomcat started on port 8081
Started RideShareApplication in X.XXX seconds
```

**You should NOT see:**
```
Exception in monitor thread while connecting to server
Connection refused
```

---

### 8️⃣ Test It!

```bash
# Test 1: Register a user
curl -X POST http://localhost:8081/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"password123","role":"ROLE_USER"}'

# Should return: {"token":"eyJhbGc..."}

# Test 2: Login
curl -X POST http://localhost:8081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"password123"}'

# Should return: {"token":"eyJhbGc..."}
```

---

## 🎉 Verify in Atlas Dashboard

1. Go to your Atlas cluster
2. Click "Browse Collections"
3. You should see:
   - Database: `rideshare`
   - Collections: `user`, `ride`
   - Documents: Your test user

---

## 🔧 Troubleshooting

### "Authentication failed"
- Double-check your username and password in the connection string
- Make sure you replaced `<password>` with actual password
- Password cannot contain special characters like `@`, `#`, `:` (use URL encoding if it does)

### "Connection timeout"
- Check Network Access in Atlas
- Make sure `0.0.0.0/0` is added
- Check your internet connection

### "Server selection timeout"
- Connection string might be wrong
- Check the cluster name in your string matches Atlas
- Make sure `/rideshare` is added before `?`

### Still stuck?
- Check logs: Look for MongoDB connection errors
- Test connection string in MongoDB Compass
- Download Compass: https://www.mongodb.com/try/download/compass

---

## 📌 Quick Reference

**Your Connection String Format:**
```
mongodb+srv://[USERNAME]:[PASSWORD]@[CLUSTER-URL]/rideshare?retryWrites=true&w=majority
```

**Example:**
```
mongodb+srv://rideshare_user:Pass123@cluster0.abc12.mongodb.net/rideshare?retryWrites=true&w=majority
```

**File to Update:**
```
src/main/resources/application.properties
```

**Property Name:**
```
spring.data.mongodb.uri
```

---

## ✅ Success Checklist

- [ ] Atlas account created
- [ ] Free M0 cluster running
- [ ] Database user created
- [ ] Network access configured (0.0.0.0/0)
- [ ] Connection string copied
- [ ] Password replaced in string
- [ ] `/rideshare` added to string
- [ ] application.properties updated
- [ ] Application rebuilt (mvn clean package)
- [ ] Application running without MongoDB errors
- [ ] Test API calls successful
- [ ] User appears in Atlas dashboard

---

**That's it! Your app is now connected to MongoDB Atlas! 🚀**
