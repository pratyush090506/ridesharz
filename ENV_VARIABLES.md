# Environment Variables for Deployment

## Backend (Spring Boot)

Required environment variables:

```bash
# MongoDB Connection
MONGODB_URI=mongodb://localhost:27017/rideshare
# For Atlas: mongodb+srv://username:password@cluster.mongodb.net/rideshare

# JWT Configuration  
JWT_SECRET=your-super-secret-jwt-key-minimum-256-bits-long
JWT_EXPIRATION=3600000

# Server Port (Railway/Render will set automatically)
PORT=8081
```

## Frontend (React)

Create `.env` file in `frontend/` directory:

```bash
# Backend API URL
VITE_API_URL=http://localhost:8081
# For production: https://your-backend.up.railway.app
```

## Railway Deployment

Set these in Railway dashboard:
- `MONGODB_URI` - Your MongoDB connection string
- `JWT_SECRET` - Generate a strong secret key

## Vercel Deployment

Set these in Vercel dashboard:
- `VITE_API_URL` - Your Railway backend URL

## MongoDB Atlas Setup

1. Create cluster at mongodb.com/cloud/atlas
2. Add IP 0.0.0.0/0 to whitelist
3. Create user with password
4. Get connection string
5. Use in MONGODB_URI
