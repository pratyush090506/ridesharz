# 🚗 RideShare - Complete Guide

## What You Have

A full-stack ride-sharing application with:
- **Backend**: Spring Boot + MongoDB (port 8081)
- **Frontend**: React (port 3000)
- **Database**: MongoDB in Docker (port 27017)

---

## Quick Start

```bash
# 1. Start MongoDB
docker start mongodb

# 2. Start Backend (from project root)
java -jar target/rideshare-1.0.0.jar > app.log 2>&1 &

# 3. Start Frontend
cd frontend && npm run dev
```

Open http://localhost:3000

---

## First Time Setup

```bash
# Backend
mvn clean package -DskipTests

# Frontend
cd frontend && npm install
```

---

## How to Use

### For Passengers:
1. Register with role "Passenger"
2. Login
3. Enter pickup and drop locations
4. Click "Book Ride"
5. View your ride status

### For Drivers:
1. Register with role "Driver"
2. Login
3. See available rides
4. Click "Accept" to take a ride
5. Click "Complete" when done

---

## Project Structure

```
ride-sharz/
├── src/                    # Backend code
├── frontend/               # React app
│   ├── src/
│   │   ├── App.jsx        # Main component
│   │   ├── App.css        # Styles
│   │   └── main.jsx       # Entry point
│   └── package.json
├── target/                 # Compiled backend
└── pom.xml                # Backend dependencies
```

---

## Stopping Everything

```bash
# Stop backend
pkill -f rideshare-1.0.0.jar

# Stop frontend (Ctrl+C in terminal)

# Stop MongoDB
docker stop mongodb
```

---

## Troubleshooting

**Frontend can't connect to backend:**
- Check backend is running: `curl http://localhost:8081/api/auth/login`
- Check CORS is enabled in SecurityConfig.java

**MongoDB connection error:**
- Start MongoDB: `docker start mongodb`
- Or run: `docker run -d --name mongodb -p 27017:27017 mongo:7.0`

**Port already in use:**
- Backend: Change in application.properties
- Frontend: Change in vite.config.js

---

## Tech Details

**Backend:**
- Java 17+
- Spring Boot 3.2.0
- MongoDB 7.0
- JWT authentication

**Frontend:**
- React 18
- Vite 5
- Axios for API
- No external UI libraries

---

Enjoy your ride-sharing app! 🚀
