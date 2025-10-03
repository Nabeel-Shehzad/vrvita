# VRVITA - Authentication & User Guide

## 📧 Hardcoded Login Credentials

### Doctor
- **Email**: `doctor@gmail.com`
- **Password**: `12345678`
- **Home Screen**: Doctor profile with bottom navigation

### Nurse
- **Email**: `nurse@gmail.com`
- **Password**: `12345678`
- **Home Screen**: Nurse profile with bottom navigation

### Team Supervisor
- **Email**: `supervisor@gmail.com`
- **Password**: `12345678`
- **Home Screen**: Supervisor profile with bottom navigation

### Training Student
- **Email**: `student@gmail.com`
- **Password**: `12345678`
- **Home Screen**: Student profile with bottom navigation

---

## 🔐 Authentication Flow

### Complete User Journey:

```
Splash (3s)
    ↓
Get Started Screen
    ↓
Choose Role (Select: Doctor, Nurse, Supervisor, or Student)
    ↓
Login Options Screen
    ├─→ Sign Up → OTP Verification → Home
    └─→ Log In → Enter Credentials → Home
```

### Login Process:
1. **Choose Your Role** - Select from 4 options
2. **Click "Log in"** button
3. **Enter Email** - Use the role-specific email above
4. **Enter Password** - Use `12345678` for all roles
5. **Click "Log in"**
6. **Navigate to Home** - Automatically redirects to role-specific home screen

### Error Handling:
- If wrong email/password entered, a red error message shows:
  - "Invalid credentials. Use [role-email] with password: 12345678"

---

## 🏠 Home Screens

Each role has a dedicated home screen with:

### Common Features:
- **Header with VRVITA branding**
- **Profile picture** (circular avatar)
- **Logout button** (top-right)
- **Back button** (top-left)
- **Edit Profile button**
- **Account section** with:
  - Edit profile
  - Security
  - Notifications (with toggle)
  - Privacy
  - Location
  - Settings
  - Help

### Bottom Navigation Bar (All Roles):
1. **Home** 🏠 - Profile and account management
2. **Search** 🔍 - Search functionality (placeholder)
3. **Add** ➕ - Add new content (placeholder)
4. **Notifications** 🔔 - View notifications (placeholder)
5. **Settings** ⚙️ - App settings (placeholder)

---

## 📁 File Structure

```
lib/
├── services/
│   └── auth_service.dart              # Hardcoded credentials & validation
│
├── screens/
│   ├── splash_screen.dart
│   ├── get_started_screen.dart
│   ├── choose_role_screen.dart
│   ├── login_screen.dart              # Sign up / Log in buttons
│   │
│   ├── auth/
│   │   ├── signup_screen.dart
│   │   ├── login_credentials_screen.dart   # Login with validation
│   │   ├── otp_screen.dart
│   │   ├── forgot_password_screen.dart
│   │   └── new_password_screen.dart
│   │
│   └── home/
│       ├── doctor_home_screen.dart    # Doctor's home with bottom nav
│       ├── nurse_home_screen.dart     # Nurse's home with bottom nav
│       ├── supervisor_home_screen.dart # Supervisor's home with bottom nav
│       └── student_home_screen.dart   # Student's home with bottom nav
```

---

## 🎨 Design Features

### Color Scheme:
- **Primary Blue**: `#4A6FA5`
- **Light Blue**: `#7BA5D8`
- **Background**: White
- **Header Gradient**: Light blue to dark blue

### UI Components:
- **Curved headers** on profile screens
- **Circular profile avatars** with white borders
- **Bottom navigation** with outlined/filled icons
- **Consistent button styling** across all screens
- **Smooth gradient backgrounds** on headers

---

## 🧪 Testing Instructions

### Test Login Flow:

1. **Start the app**
2. **Wait for splash screen** (3 seconds)
3. **Click "Get started!"**
4. **Select "Doctor"** role
5. **Click "Log in"**
6. **Enter credentials:**
   - Username: `doctor@gmail.com`
   - Password: `12345678`
7. **Click "Log in"**
8. **Verify:** Should navigate to Doctor Home Screen

### Test Different Roles:

Repeat the above process with:
- **Nurse**: `nurse@gmail.com` / `12345678`
- **Team Supervisor**: `supervisor@gmail.com` / `12345678`
- **Training Student**: `student@gmail.com` / `12345678`

### Test Error Handling:

1. Enter **wrong email** → Should show error message
2. Enter **wrong password** → Should show error message
3. Error message should display correct email for the selected role

---

## 🚀 Next Steps (TODO)

### Authentication:
- [ ] Integrate real backend API
- [ ] Implement JWT token authentication
- [ ] Add session management
- [ ] Implement actual OTP sending/verification
- [ ] Add biometric authentication

### Features:
- [ ] Complete Profile Edit functionality
- [ ] Implement Search feature
- [ ] Add VR Appointments booking
- [ ] Create Notifications list
- [ ] Build Settings screens
- [ ] Add Contact Us functionality
- [ ] Implement real user data

### UI Enhancements:
- [ ] Add loading indicators
- [ ] Implement smooth page transitions
- [ ] Add profile image upload
- [ ] Create custom app theme
- [ ] Add dark mode support

---

## 📞 Support

For issues or questions, refer to the Contact Us screen in the app or check the Help section.

---

**Version**: 1.0.0  
**Last Updated**: October 3, 2025
