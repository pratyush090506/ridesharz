# 📸 Screenshots & Demo Guide

## What to Include in Submission

### Screenshots to Take:

1. **Login Page**
   - Clean UI showing RideSharz branding
   - Login/Register tabs

2. **Dashboard - Passenger View**
   - "Request a Ride" form
   - List of user's rides
   - Status indicators

3. **Dashboard - Driver View**
   - Available rides list
   - Accept/Complete buttons
   - Ride details

4. **Mobile Responsive View** (optional)
   - Shows app works on phone

### Demo Flow:

**Scenario 1: Passenger Books Ride**
1. Register as passenger
2. Login
3. Enter pickup: "123 Main St, Boston"
4. Enter drop: "456 Park Ave, Boston"
5. Click "Book Ride"
6. See ride with status "REQUESTED"

**Scenario 2: Driver Accepts Ride**
1. Register as driver
2. Login  
3. See available rides
4. Click "Accept" on a ride
5. Ride status changes to "ACCEPTED"
6. Click "Complete"
7. Ride status changes to "COMPLETED"

### For Video Demo (1-2 minutes):

1. Show homepage/login
2. Register passenger account
3. Create a ride request
4. Switch to driver account
5. Accept the ride
6. Complete the ride
7. Show both user's ride history

### Code Walkthrough Points:

**Backend:**
- Show SecurityConfig.java (JWT + CORS)
- Show RideController.java (REST endpoints)
- Show JwtAuthenticationFilter.java (security)

**Frontend:**
- Show App.jsx (main component)
- Show API calls with axios
- Show responsive CSS

### GitHub Repository Checklist:

✓ Clear README.md
✓ Well-structured folders
✓ No node_modules committed
✓ .gitignore properly set
✓ Comments in code (minimal, natural)
✓ Environment variable examples

### Live Demo Checklist:

✓ Site loads without errors
✓ Can register new users
✓ Can login successfully
✓ Can create rides
✓ Can accept rides (as driver)
✓ Status updates work
✓ Responsive on mobile

---

## How to Take Screenshots

**macOS:**
- Cmd + Shift + 4 = Select area
- Cmd + Shift + 3 = Full screen

**Windows:**
- Win + Shift + S = Snipping tool

---

## Record Screen Demo

**macOS:**
- QuickTime Player → File → New Screen Recording

**Windows:**
- Xbox Game Bar (Win + G)

**Online:**
- Loom.com (free, shareable link)

---

## Hosting Screenshots

Upload to:
- GitHub repo (create `screenshots/` folder)
- Imgur.com (free)
- Google Drive (share link)

Add to README.md:
```markdown
## Screenshots

![Login](screenshots/login.png)
![Dashboard](screenshots/dashboard.png)
```

---

Ready to show off your work! 📸
