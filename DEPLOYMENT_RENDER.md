# Render Deployment Guide

## Step 1: Prepare Files

Create these files in your project root:

### `render.yaml` (for backend)
```yaml
services:
  - type: web
    name: ridesharz-backend
    env: java
    buildCommand: mvn clean package -DskipTests
    startCommand: java -jar target/rideshare-1.0.0.jar
    envVars:
      - key: MONGODB_URI
        sync: false
      - key: JWT_SECRET
        generateValue: true
```

## Step 2: Deploy Backend

1. Go to https://render.com
2. Sign in with GitHub
3. Click "New +" → "Web Service"
4. Connect your GitHub repo
5. Configure:
   - Name: ridesharz-backend
   - Build Command: `mvn clean package -DskipTests`
   - Start Command: `java -jar target/rideshare-1.0.0.jar`
6. Add MongoDB:
   - Create new MongoDB on Render OR use Atlas
7. Add environment variables in Render dashboard

## Step 3: Deploy Frontend

1. Click "New +" → "Static Site"
2. Select your repo
3. Configure:
   - Root Directory: `frontend`
   - Build Command: `npm install && npm run build`
   - Publish Directory: `dist`
4. Add environment variable:
   - `VITE_API_URL` = your-backend-url

Done! Your app is live.
