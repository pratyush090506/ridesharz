# 🚀 RideShare Backend – Student Helper Document

## Quick Start Guide

This document provides a complete reference for building and understanding the RideShare backend project.

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Entities & Relationships](#entities--relationships)
3. [Folder Structure](#folder-structure)
4. [Feature Checklist](#feature-checklist)
5. [Input Validation](#input-validation)
6. [Global Exception Handling](#global-exception-handling)
7. [JWT Authentication](#jwt-authentication)
8. [API Summary](#api-summary)
9. [cURL Commands](#curl-commands)
10. [Submission Requirements](#submission-requirements)

---

## 1️⃣ Project Overview

Build a mini Ride Sharing backend using:
- **Spring Boot** - REST API framework
- **MongoDB** - NoSQL database
- **JWT Authentication** - Secure token-based auth
- **Input Validation** - Jakarta Validation
- **Global Exception Handling** - Centralized error responses

**Architecture Pattern:**
```
Request → Controller → Service → Repository → MongoDB
```

---

## 2️⃣ Entities & Relationships

### 📌 Entity 1 — User

```
User
 ├─ id : String (MongoDB _id)
 ├─ username : String (unique)
 ├─ password : String (BCrypt encoded)
 └─ role : String (ROLE_USER / ROLE_DRIVER)
```

### 📌 Entity 2 — Ride

```
Ride
 ├─ id : String (MongoDB _id)
 ├─ userId : String (FK → User)
 ├─ driverId : String? (FK → User, nullable)
 ├─ pickupLocation : String
 ├─ dropLocation : String
 ├─ status : String (REQUESTED / ACCEPTED / COMPLETED)
 └─ createdAt : Date
```

### 📌 Relationship Diagram

```
 USER (ROLE_USER)       DRIVER (ROLE_DRIVER)
        │                         │
        │ requests                │ accepts
        ▼                         ▼
    ┌────────────────────────────────┐
    │              RIDE              │
    ├────────────────────────────────┤
    │ userId     → USER.id          │
    │ driverId   → DRIVER.id        │
    │ status     → REQUESTED/ACCEPT │
    └────────────────────────────────┘
```

---

## 3️⃣ Folder Structure

**Students MUST Follow Exactly:**

```
src/
 ├── main/
 │    ├── java/
 │    │     └── org/example/rideshare/
 │    │           ├── model/              # User.java, Ride.java
 │    │           ├── repository/         # UserRepository, RideRepository
 │    │           ├── service/            # AuthService, RideService
 │    │           ├── controller/         # AuthController, RideController, etc.
 │    │           ├── config/             # SecurityConfig, JwtAuthenticationFilter
 │    │           ├── dto/                # DTOs with validation
 │    │           ├── exception/          # Custom exceptions + GlobalExceptionHandler
 │    │           ├── util/               # JwtUtil
 │    │           └── RideShareApplication.java
 │    └── resources/
 │            └── application.properties
 └── pom.xml
```

---

## 4️⃣ Feature Checklist

### ✅ Must Implement

#### 🧑‍🤝‍🧑 User Registration + Login (JWT)

**Endpoints:**
- `POST /api/auth/register`
- `POST /api/auth/login`

**Rules:**
- Store password BCrypt encoded
- Return JWT token on login
- User role is either `ROLE_USER` or `ROLE_DRIVER`

#### 🚕 Request a Ride (Passenger)

**Endpoint:** `POST /api/v1/rides`

**Request Body:**
```json
{
  "pickupLocation": "Koramangala",
  "dropLocation": "Indiranagar"
}
```

**Rules:**
- Must be logged in as `ROLE_USER`
- Status = `REQUESTED`
- userId = logged in user's ID

#### 🚗 Driver: View Pending Ride Requests

**Endpoint:** `GET /api/v1/driver/rides/requests`

Returns all rides with status `REQUESTED`.

#### ✔ Driver Accepts a Ride

**Endpoint:** `POST /api/v1/driver/rides/{rideId}/accept`

**Rules:**
- Must have `ROLE_DRIVER`
- Ride must be `REQUESTED`
- Assign driverId = logged in driver id
- Status → `ACCEPTED`

#### ✔ Complete Ride

**Endpoint:** `POST /api/v1/rides/{rideId}/complete`

**Rules:**
- Must be `ACCEPTED`
- Only the passenger (userId) or assigned driver (driverId) can complete
- Set status → `COMPLETED`

#### ✔ User Gets Their Own Rides

**Endpoint:** `GET /api/v1/user/rides`

Filter rides by userId.

---

## 5️⃣ Input Validation

### Jakarta Validation Annotations

Use these in your DTOs:

| Annotation | Description | Example |
|------------|-------------|---------|
| `@NotBlank` | Field cannot be null or empty | `@NotBlank(message = "Username is required")` |
| `@Size(min, max)` | String length constraint | `@Size(min = 3, message = "Min 3 chars")` |
| `@Valid` | Triggers validation on nested objects | Use in controller params |

### Example DTO

```java
public class CreateRideRequest {
    @NotBlank(message = "Pickup is required")
    private String pickupLocation;

    @NotBlank(message = "Drop is required")
    private String dropLocation;
    
    // getters & setters
}
```

### Controller Usage

```java
@PostMapping("/api/v1/rides")
public ResponseEntity<RideResponse> createRide(
    @Valid @RequestBody CreateRideRequest req, 
    Principal principal) {
    // ...
}
```

---

## 6️⃣ Global Exception Handling

### Exception Classes

```
exception/
 ├── GlobalExceptionHandler.java
 ├── NotFoundException.java
 ├── BadRequestException.java
 ├── UnauthorizedException.java
 └── ErrorResponse.java
```

### Error Response Format

```json
{
  "error": "VALIDATION_ERROR",
  "message": "Pickup is required",
  "timestamp": "2025-01-20T12:00:00Z"
}
```

### Exception Mapping

| Exception | HTTP Status | Error Code |
|-----------|-------------|------------|
| `MethodArgumentNotValidException` | 400 | VALIDATION_ERROR |
| `NotFoundException` | 404 | NOT_FOUND |
| `BadRequestException` | 400 | BAD_REQUEST |
| `UnauthorizedException` | 401 | UNAUTHORIZED |
| `JwtException` | 401 | UNAUTHORIZED |
| Generic `Exception` | 500 | INTERNAL_ERROR |

---

## 7️⃣ JWT Authentication

### JWT Flow Diagram

```
LOGIN → JWT TOKEN → STORE IN CLIENT → SEND WITH EVERY REQUEST
```

### Token Structure

**Header:**
```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

**Payload:**
```json
{
  "sub": "john",
  "role": "ROLE_USER",
  "iat": 1733484000,
  "exp": 1733487600
}
```

**Signature:** HMAC with secret key

### Authorization Header

```
Authorization: Bearer <token>
```

### JWT Configuration

In `application.properties`:
```properties
rideshare.jwt.secret=your-very-long-secret-key-at-least-256-bits
rideshare.jwt.expirationMs=3600000
```

### Key Components

1. **JwtUtil** - Generate & validate tokens
2. **JwtAuthenticationFilter** - Intercept requests, validate token
3. **SecurityConfig** - Configure security rules
4. **PasswordEncoder** - BCrypt for password encryption

---

## 8️⃣ API Summary

| Role | Endpoint | Action |
|------|----------|--------|
| **PUBLIC** | `POST /api/auth/register` | Create User |
| **PUBLIC** | `POST /api/auth/login` | Return JWT |
| **USER** | `POST /api/v1/rides` | Create Ride |
| **USER** | `GET /api/v1/user/rides` | View My Rides |
| **DRIVER** | `GET /api/v1/driver/rides/requests` | View All Pending |
| **DRIVER** | `POST /api/v1/driver/rides/{id}/accept` | Accept Ride |
| **USER/DRIVER** | `POST /api/v1/rides/{id}/complete` | Complete Ride |

---

## 9️⃣ cURL Commands

### 1. Register USER

```bash
curl -X POST http://localhost:8081/api/auth/register \
-H "Content-Type: application/json" \
-d '{"username":"john","password":"1234","role":"ROLE_USER"}'
```

### 2. Register DRIVER

```bash
curl -X POST http://localhost:8081/api/auth/register \
-H "Content-Type: application/json" \
-d '{"username":"driver1","password":"abcd","role":"ROLE_DRIVER"}'
```

### 3. Login

```bash
curl -X POST http://localhost:8081/api/auth/login \
-H "Content-Type: application/json" \
-d '{"username":"john","password":"1234"}'
```

**Response:**
```json
{"token":"eyJhbGciOiJIUzI1NiJ9..."}
```

### 4. Create Ride

```bash
curl -X POST http://localhost:8081/api/v1/rides \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <token>" \
-d '{"pickupLocation":"Koramangala","dropLocation":"Indiranagar"}'
```

### 5. View Pending Rides (Driver)

```bash
curl -X GET http://localhost:8081/api/v1/driver/rides/requests \
-H "Authorization: Bearer <driverToken>"
```

### 6. Accept Ride (Driver)

```bash
curl -X POST http://localhost:8081/api/v1/driver/rides/{rideId}/accept \
-H "Authorization: Bearer <driverToken>"
```

### 7. Complete Ride

```bash
curl -X POST http://localhost:8081/api/v1/rides/{rideId}/complete \
-H "Authorization: Bearer <token>"
```

### 8. View My Rides (User)

```bash
curl -X GET http://localhost:8081/api/v1/user/rides \
-H "Authorization: Bearer <userToken>"
```

---

## 🔟 Submission Requirements

### Student Assignment Checklist

- [ ] **Complete functioning API**
- [ ] **Proper folder structure** (as specified)
- [ ] **DTOs + Validation** (Jakarta annotations)
- [ ] **Exception Handling** (GlobalExceptionHandler)
- [ ] **JWT Auth** implemented correctly
- [ ] **All Endpoints** working:
  - [ ] Register & Login
  - [ ] Create Ride
  - [ ] View My Rides
  - [ ] View Pending Rides (Driver)
  - [ ] Accept Ride (Driver)
  - [ ] Complete Ride
- [ ] **Role-based Authorization**
- [ ] **README** with setup instructions
- [ ] **Postman Collection** (optional)

### Grading Rubric (Suggested)

| Category | Points | Criteria |
|----------|--------|----------|
| **Authentication & Security** | 30% | JWT correct, BCrypt, role-based access |
| **Business Logic** | 30% | Ride lifecycle, state transitions |
| **Validation & Exceptions** | 20% | Input validation, proper error handling |
| **Code Structure** | 10% | Clean architecture, folder structure |
| **Documentation** | 10% | README, API docs, comments |

---

## 🎯 Business Rules Summary

1. **Registration**
   - Username must be unique
   - Role: `ROLE_USER` or `ROLE_DRIVER`
   - Password encrypted with BCrypt

2. **Create Ride**
   - Only `ROLE_USER` can create
   - Initial status: `REQUESTED`
   - userId set to authenticated user

3. **Accept Ride**
   - Only `ROLE_DRIVER` can accept
   - Ride must be `REQUESTED`
   - Sets driverId and status to `ACCEPTED`

4. **Complete Ride**
   - Ride must be `ACCEPTED`
   - Only passenger or assigned driver can complete
   - Sets status to `COMPLETED`

---

## 🔐 Security Implementation Notes

### Password Encryption
```java
// In SecurityConfig
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}

// In AuthService (register)
user.setPassword(passwordEncoder.encode(request.getPassword()));

// In AuthService (login)
passwordEncoder.matches(rawPassword, encodedPassword)
```

### JWT Generation
```java
String token = Jwts.builder()
    .subject(username)
    .claim("role", role)
    .issuedAt(new Date())
    .expiration(new Date(System.currentTimeMillis() + expirationMs))
    .signWith(getSigningKey())
    .compact();
```

### Authentication Filter
1. Extract `Authorization` header
2. Parse `Bearer <token>`
3. Validate token
4. Extract username & role
5. Create `Authentication` object
6. Set in `SecurityContext`

---

## 🛠️ Common Issues & Solutions

### Issue: MongoDB Connection Failed
**Solution:** Ensure MongoDB is running
```bash
brew services start mongodb-community
```

### Issue: JWT Token Invalid
**Check:**
- Secret key is at least 256 bits (32 characters)
- Token is not expired
- Token format is `Bearer <token>`

### Issue: 403 Forbidden
**Causes:**
- Wrong role for endpoint
- Missing JWT token
- Token expired
- CSRF enabled (should be disabled for API)

### Issue: Validation Not Working
**Check:**
- `@Valid` annotation on controller parameter
- Validation annotations on DTO fields
- `spring-boot-starter-validation` dependency

---

## 📚 Key Technologies

- **Spring Boot 3.2.0** - Application framework
- **Spring Data MongoDB** - Database integration
- **Spring Security** - Authentication & authorization
- **JJWT 0.12.3** - JWT implementation
- **Jakarta Validation** - Input validation
- **Lombok** - Reduce boilerplate code
- **BCrypt** - Password hashing

---

## 🚀 Run Commands

### Build Project
```bash
mvn clean install
```

### Run Application
```bash
mvn spring-boot:run
```

### Or using wrapper
```bash
./mvnw spring-boot:run
```

### Test Complete Workflow
```bash
chmod +x test-workflow.sh
./test-workflow.sh
```

---

## 📖 Additional Resources

- [Spring Boot Docs](https://spring.io/projects/spring-boot)
- [Spring Security Reference](https://docs.spring.io/spring-security/reference/)
- [JWT.io Debugger](https://jwt.io/)
- [MongoDB Spring Data](https://docs.spring.io/spring-data/mongodb/docs/current/reference/html/)
- [Jakarta Bean Validation](https://beanvalidation.org/)

---

## ✨ Tips for Success

1. **Start with models** - Define entities first
2. **Test as you go** - Don't wait until the end
3. **Use Postman** - Import the collection for easy testing
4. **Check logs** - Enable DEBUG logging for troubleshooting
5. **Handle edge cases** - What if ride doesn't exist? Already accepted?
6. **Validate inputs** - Use Jakarta validation annotations
7. **Secure endpoints** - Proper role-based access control
8. **Document your code** - Add comments for complex logic

---

**Good luck with your project! 🚀**

---

*This is a student learning project. For production use, additional features like proper logging, comprehensive testing, API documentation (Swagger), rate limiting, and more robust error handling would be required.*
