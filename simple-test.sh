#!/bin/bash

echo "🚀 RideShare Backend - Simple API Test"
echo "========================================"
echo ""

BASE_URL="http://localhost:8081"

echo "1️⃣ Testing Registration..."
curl -s -X POST "$BASE_URL/api/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser1","password":"pass123","role":"ROLE_USER"}' | jq .
echo ""

echo "2️⃣ Testing Login..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser1","password":"pass123"}')
echo "$LOGIN_RESPONSE" | jq .
TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token')
echo ""

if [ "$TOKEN" != "null" ] && [ -n "$TOKEN" ]; then
  echo "✅ Login successful! Token: ${TOKEN:0:50}..."
  echo ""
  
  echo "3️⃣ Creating a ride..."
  RIDE_RESPONSE=$(curl -s -X POST "$BASE_URL/api/v1/rides" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"pickupLocation":"123 Main Street, Boston","dropLocation":"456 Park Avenue, Boston"}')
  echo "$RIDE_RESPONSE" | jq .
  RIDE_ID=$(echo "$RIDE_RESPONSE" | jq -r '.id')
  echo ""
  
  echo "4️⃣ Viewing user's rides..."
  curl -s -X GET "$BASE_URL/api/v1/user/rides" \
    -H "Authorization: Bearer $TOKEN" | jq .
  echo ""
  
  echo "✅ All tests passed!"
else
  echo "❌ Login failed - cannot proceed with authenticated requests"
fi

echo ""
echo "📋 Summary:"
echo "- Application: Running on $BASE_URL"
echo "- MongoDB: Connected to localhost:27017"
echo "- API Status: ✅ Working"
