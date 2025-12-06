# 🚀 RideSharz Backend - Student Mini Project

A complete ride-sharing backend application built with **Spring Boot**, **MongoDB**, and **JWT Authentication**.

## 🌐 Front-end Website: https://ridesharz.netlify.app/

## 📋 Project Overview

This project implements a mini ride-sharing system with:
- ✅ User Registration & JWT-based Authentication
- ✅ Role-based Authorization (USER / DRIVER)
- ✅ Ride Request Management
- ✅ Driver Accept/Complete Workflow
- ✅ Input Validation with Jakarta Validation
- ✅ Global Exception Handling
- ✅ Clean Architecture (Controller → Service → Repository)

## 🛠️ Tech Stack

- **Framework**: Spring Boot 3.2.0
- **Database**: MongoDB
- **Security**: Spring Security + JWT (jjwt 0.12.3)
- **Validation**: Jakarta Validation
- **Build Tool**: Maven
- **Java Version**: 17

## 📁 Project Structure

```
src/main/java/org/example/rideshare/
├── model/              # MongoDB entities (User, Ride)
├── repository/         # Spring Data MongoDB repositories
├── service/            # Business logic layer
├── controller/         # REST API endpoints
├── config/             # Security & JWT configuration
├── dto/                # Data Transfer Objects with validation
├── exception/          # Custom exceptions & global handler
└── util/               # JWT utility class
```

## 🔑 Key Features

### 1. User Management
- **Register**: Create USER or DRIVER account with BCrypt password encryption
- **Login**: Authenticate and receive JWT token

### 2. Ride Lifecycle
- **REQUESTED** → User creates a ride request
- **ACCEPTED** → Driver accepts the ride
- **COMPLETED** → User or driver marks ride as complete

### 3. Security
- JWT token-based authentication
- Role-based access control (ROLE_USER, ROLE_DRIVER)
- Stateless session management
- BCrypt password encryption

## 🚀 Getting Started

### Prerequisites
- Java 17 or higher
- Maven 3.6+
- MongoDB running on `localhost:27017`

### Installation & Setup

1. **Clone the repository**
```bash
cd ride-sharz
```

2. **Ensure MongoDB is running**
```bash
# macOS with Homebrew
brew services start mongodb-community

# Or run manually
mongod --dbpath /path/to/data/db
```

3. **Configure application.properties** (optional)
Update `src/main/resources/application.properties` if needed:
```properties
server.port=8081
spring.data.mongodb.uri=mongodb://localhost:27017/rideshare
rideshare.jwt.secret=your-secret-key
rideshare.jwt.expirationMs=3600000
```

4. **Build and run**
```bash
# Using Maven wrapper
./mvnw clean install
./mvnw spring-boot:run

# Or using Maven
mvn clean install
mvn spring-boot:run
```

The application will start on `http://localhost:8081`

## 📡 API Endpoints

### Authentication (Public)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/auth/register` | Register new user | No |
| POST | `/api/auth/login` | Login and get JWT | No |

### User Endpoints (ROLE_USER)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/rides` | Create ride request | Yes (USER) |
| GET | `/api/v1/user/rides` | View my rides | Yes (USER) |

### Driver Endpoints (ROLE_DRIVER)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/driver/rides/requests` | View pending rides | Yes (DRIVER) |
| POST | `/api/v1/driver/rides/{id}/accept` | Accept a ride | Yes (DRIVER) |

### Shared Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/rides/{id}/complete` | Complete ride | Yes (USER or DRIVER) |

## 🧪 Testing with cURL

### 1. Register a User
```bash
curl -X POST http://localhost:8081/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john",
    "password": "1234",
    "role": "ROLE_USER"
  }'
```

### 2. Register a Driver
```bash
curl -X POST http://localhost:8081/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "driver1",
    "password": "abcd",
    "role": "ROLE_DRIVER"
  }'
```

### 3. Login as User
```bash
curl -X POST http://localhost:8081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john",
    "password": "1234"
  }'
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

### 4. Create Ride Request (as User)
```bash
curl -X POST http://localhost:8081/api/v1/rides \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_USER_TOKEN" \
  -d '{
    "pickupLocation": "Koramangala",
    "dropLocation": "Indiranagar"
  }'
```

### 5. View Pending Rides (as Driver)
```bash
curl -X GET http://localhost:8081/api/v1/driver/rides/requests \
  -H "Authorization: Bearer YOUR_DRIVER_TOKEN"
```

### 6. Accept Ride (as Driver)
```bash
curl -X POST http://localhost:8081/api/v1/driver/rides/RIDE_ID/accept \
  -H "Authorization: Bearer YOUR_DRIVER_TOKEN"
```

### 7. Complete Ride (as User or Driver)
```bash
curl -X POST http://localhost:8081/api/v1/rides/RIDE_ID/complete \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 8. View My Rides (as User)
```bash
curl -X GET http://localhost:8081/api/v1/user/rides \
  -H "Authorization: Bearer YOUR_USER_TOKEN"
```

## 📝 Request/Response Examples

### Register Request
```json
{
  "username": "john",
  "password": "1234",
  "role": "ROLE_USER"
}
```

### Login Response
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqb2huIiwicm9sZSI6IlJPTEVfVVNFUiIsImlhdCI6MTczMzQ4NDAwMCwiZXhwIjoxNzMzNDg3NjAwfQ..."
}
```

### Create Ride Response
```json
{
  "id": "675c1a2b3d4e5f6g7h8i9j0k",
  "userId": "675c1a2b3d4e5f6g7h8i9j0a",
  "driverId": null,
  "pickupLocation": "Koramangala",
  "dropLocation": "Indiranagar",
  "status": "REQUESTED",
  "createdAt": "2025-12-06T10:30:00.000+00:00"
}
```

### Error Response
```json
{
  "error": "VALIDATION_ERROR",
  "message": "Pickup location is required",
  "timestamp": "2025-12-06T10:30:00.123Z"
}
```

## 🔐 Security Implementation

### JWT Token Structure
- **Header**: Algorithm (HS256)
- **Payload**: username, role, issuedAt, expiration
- **Signature**: HMAC with secret key

### Authorization Flow
1. User registers → password encrypted with BCrypt
2. User logs in → JWT token generated and returned
3. Client stores token
4. Client sends token in `Authorization: Bearer <token>` header
5. JwtAuthenticationFilter validates token on each request
6. Spring Security enforces role-based access

## 🎯 Business Rules

1. **Registration**
   - Username must be unique
   - Role must be either ROLE_USER or ROLE_DRIVER
   - Password encrypted with BCrypt

2. **Create Ride**
   - Only ROLE_USER can create rides
   - Initial status: REQUESTED
   - userId set to authenticated user

3. **Accept Ride**
   - Only ROLE_DRIVER can accept
   - Ride must be in REQUESTED status
   - Sets driverId and changes status to ACCEPTED

4. **Complete Ride**
   - Ride must be in ACCEPTED status
   - Only the passenger (userId) or assigned driver (driverId) can complete
   - Changes status to COMPLETED

## 🏗️ Architecture

### Clean Layer Architecture
```
Controller → Service → Repository → MongoDB
     ↓          ↓
   DTO      Business Logic
```

### Exception Handling
- `NotFoundException` → 404
- `BadRequestException` → 400
- `UnauthorizedException` → 401
- `MethodArgumentNotValidException` → 400 (validation)
- Generic `Exception` → 500

## ✅ Student Submission Checklist

- [x] Complete folder structure implemented
- [x] User registration with BCrypt password encryption
- [x] JWT token generation and validation
- [x] DTOs with Jakarta Validation annotations
- [x] Global exception handler with proper error responses
- [x] All required endpoints implemented:
  - [x] Register & Login
  - [x] Create Ride (USER)
  - [x] View My Rides (USER)
  - [x] View Pending Rides (DRIVER)
  - [x] Accept Ride (DRIVER)
  - [x] Complete Ride (USER/DRIVER)
- [x] Role-based authorization
- [x] Clean architecture (Controller → Service → Repository)
- [x] README with setup and API documentation
- [x] .gitignore file

## 📚 Key Concepts Covered

- Spring Boot REST API development
- MongoDB with Spring Data
- JWT authentication implementation
- Spring Security configuration
- Role-based authorization
- Bean Validation (Jakarta)
- Global exception handling
- DTO pattern
- Repository pattern
- Service layer pattern

## 🐛 Troubleshooting

### MongoDB Connection Issues
```bash
# Check if MongoDB is running
ps aux | grep mongod

# Start MongoDB
brew services start mongodb-community
```

### Port Already in Use
Change the port in `application.properties`:
```properties
server.port=8082
```

### JWT Secret Key Error
Ensure the secret key in `application.properties` is at least 256 bits (32 characters) for HS256.

## 📖 Additional Resources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Spring Security Reference](https://docs.spring.io/spring-security/reference/)
- [JWT.io](https://jwt.io/) - JWT debugger
- [MongoDB Spring Data](https://docs.spring.io/spring-data/mongodb/docs/current/reference/html/)

## 👨‍💻 Author

**Student Mini Project**  
RideShare Backend Implementation

---

**Note**: This is a learning project for educational purposes. For production use, additional security measures, error handling, and testing would be required.
