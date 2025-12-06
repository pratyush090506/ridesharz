#!/bin/bash

# RideShare Backend - Quick Test Script
# This script demonstrates the complete ride workflow

BASE_URL="http://localhost:8081"

echo "🚀 RideShare Backend - Testing Workflow"
echo "========================================"
echo ""

# Step 1: Register User
echo "1️⃣ Registering User (john)..."
curl -s -X POST "$BASE_URL/api/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"username":"john","password":"1234","role":"ROLE_USER"}' | jq '.'
echo ""

# Step 2: Register Driver
echo "2️⃣ Registering Driver (driver1)..."
curl -s -X POST "$BASE_URL/api/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"username":"driver1","password":"abcd","role":"ROLE_DRIVER"}' | jq '.'
echo ""

# Step 3: Login as User
echo "3️⃣ Logging in as User..."
USER_TOKEN=$(curl -s -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"john","password":"1234"}' | jq -r '.token')
echo "User Token: ${USER_TOKEN:0:50}..."
echo ""

# Step 4: Login as Driver
echo "4️⃣ Logging in as Driver..."
DRIVER_TOKEN=$(curl -s -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"driver1","password":"abcd"}' | jq -r '.token')
echo "Driver Token: ${DRIVER_TOKEN:0:50}..."
echo ""

# Step 5: User creates ride
echo "5️⃣ User creating ride request..."
RIDE_RESPONSE=$(curl -s -X POST "$BASE_URL/api/v1/rides" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $USER_TOKEN" \
  -d '{"pickupLocation":"Koramangala","dropLocation":"Indiranagar"}')
echo "$RIDE_RESPONSE" | jq '.'
RIDE_ID=$(echo "$RIDE_RESPONSE" | jq -r '.id')
echo "Ride ID: $RIDE_ID"
echo ""

# Step 6: Driver views pending rides
echo "6️⃣ Driver viewing pending rides..."
curl -s -X GET "$BASE_URL/api/v1/driver/rides/requests" \
  -H "Authorization: Bearer $DRIVER_TOKEN" | jq '.'
echo ""

# Step 7: Driver accepts ride
echo "7️⃣ Driver accepting ride..."
curl -s -X POST "$BASE_URL/api/v1/driver/rides/$RIDE_ID/accept" \
  -H "Authorization: Bearer $DRIVER_TOKEN" | jq '.'
echo ""

# Step 8: User views their rides
echo "8️⃣ User viewing their rides..."
curl -s -X GET "$BASE_URL/api/v1/user/rides" \
  -H "Authorization: Bearer $USER_TOKEN" | jq '.'
echo ""

# Step 9: Complete ride
echo "9️⃣ Completing ride..."
curl -s -X POST "$BASE_URL/api/v1/rides/$RIDE_ID/complete" \
  -H "Authorization: Bearer $USER_TOKEN" | jq '.'
echo ""

echo "✅ Workflow completed successfully!"
echo ""
echo "📝 Note: Make sure MongoDB is running and the application is started on port 8081"
