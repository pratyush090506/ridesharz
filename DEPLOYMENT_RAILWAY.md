# Railway Deployment Guide

## Step 1: Prepare Your Project

1. Create a GitHub repository
2. Push your code to GitHub

## Step 2: Deploy Backend on Railway

1. Go to https://railway.app
2. Sign in with GitHub
3. Click "New Project"
4. Select "Deploy from GitHub repo"
5. Choose your repo
6. Railway will auto-detect Spring Boot
7. Add MongoDB:
   - Click "New" → "Database" → "MongoDB"
   - Railway will provide connection string
8. Add environment variables:
   - `MONGODB_URI` = (Railway MongoDB URL)
   - `JWT_SECRET` = your-secret-key

## Step 3: Deploy Frontend

### Option A: On Railway
1. Create new service
2. Select same repo
3. Set root directory to `/frontend`
4. Add environment variable:
   - `VITE_API_URL` = your-backend-url

### Option B: On Vercel (Better for React)
1. Go to https://vercel.com
2. Import from GitHub
3. Set root directory: `frontend`
4. Add environment variable:
   - `VITE_API_URL` = your-backend-url
5. Deploy!

## URLs You'll Get
- Backend: https://your-app.up.railway.app
- Frontend: https://your-app.vercel.app

Total time: ~10 minutes
