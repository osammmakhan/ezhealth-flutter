# ezHealth ⚕️

A modern Flutter-based project for managing healthcare appointments, designed to enhance the efficiency of healthcare services and improve the patient experience.

---

## Table of Contents

1. [Overview](#overview)
2. [Technologies Used](#technologies-used)
3. [Features](#features)
   - [Patient Module](#patient-module)
   - [Doctor Module](#doctor-module)
   - [Admin Module](#admin-module)
4. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Installation Steps](#installation-steps)
5. [Project Structure](#project-structure)
6. [Firebase Integration](#firebase-integration)
   - [Configuration](#configuration)
7. [Firebase Secrets](#firebase-secrets)
8. [Testing the Application](#testing-the-application)
   - [Credentials for Testing](#credentials-for-testing)
9. [APK Download](#apk-download)

---

## Overview

EzHealth is a comprehensive solution addressing inefficiencies in Pakistan's healthcare system caused by outdated appointment scheduling methods. It provides seamless communication between patients, doctors, and administrative staff, offering features like real-time updates, emergency prioritization, and support for both digital and manual booking.

## Demo 🎥

Watch the app in action below:


https://github.com/user-attachments/assets/130797ec-f8e9-419f-80fa-9ca35952e1c7



### Key Objectives:
- 🔒 Replace time-consuming paper-based processes with a user-friendly digital platform.
- ✅ Eliminate scheduling conflicts and reduce manual errors.
- ⏳ Minimize long wait times and administrative inefficiencies.
- 📄 Enhance the booking process for patients and healthcare providers alike.

---

## Technologies Used

We have utilized the following technologies to build EzHealth:
- 🛠 **Flutter**: For crafting the user interface.
- 🗂 **Provider**: For efficient state management.
- 🔐 **Firebase**: For authentication, user management, and notifications.
- 📆 **Firestore**: For real-time database operations.

---

## Features

### Patient Module
- 🗂 **Appointment Booking:** Easily book appointments.
- ✉️ **Notifications:** Receive real-time updates and reminders.
- ⏰ **Tracking:** Manage and track appointments, including emergencies.

### Doctor Module
- 🕒 **Schedule Management:** View and manage daily schedules.
- 📋 **History Access:** Access patient appointment histories.
- ⚕️ **Consultations:** Start and end consultations with ease.

### Admin Module
- 🛒 **Manual Bookings:** Add walk-in and emergency appointments.
- ⚠️ **Conflict Resolution:** Manage scheduling conflicts and prioritize urgent cases.
- 🔄 **Appointment Control:** Approve, reschedule, or cancel appointments.

---

## Getting Started

### Prerequisites

Ensure the following tools are installed:
- 🔄 [Flutter](https://flutter.dev/docs/get-started/install)
- ⚡️ [Firebase CLI](https://firebase.google.com/docs/cli)

### Installation Steps

1. **Clone the Repository:**
    ```bash
    git clone https://github.com/osammmakhan/ezhealth.git
    cd ez_health
    ```

2. **Install Dependencies:**
    ```bash
    flutter pub get
    ```

3. **Set Up Firebase:**
    - 🔧 Create a Firebase project.
    - 🔐 Download and add the `google-services.json` file to your project.

4. **Run the Application:**
    ```bash
    flutter run
    ```

---

## Project Structure

The project is organized as follows:

- **lib/main.dart**: ⚛️ Entry point of the application.
- **lib/onboarding_screen.dart**: 📖 Onboarding screen for new users.
- **lib/auth.dart**: ✔️ Authentication screen for sign-in and sign-up.
- **lib/patient/appointment/**:
  - **patient_appointment_screen.dart**: ⏳ Manage patient appointments.
  - **patient_details_screen.dart**: 🔐 Enter patient details.
- **lib/patient/payment/**:
  - **payment_methods_screen.dart**: 💳 Manage payment methods.
  - **payment_details_screen.dart**: 📝 Enter payment details.
- **lib/patient/patient_home_screen.dart**: 🏥 Home screen for patients.
- **lib/admin/admin_home_screen.dart**: 🏢 Home screen for admin users.
- **lib/doctor/doctor_home_screen.dart**: ⚕️ Home screen for doctors.
- **lib/notification_screen.dart**: 📢 Display notifications.
- **lib/providers/**:
  - **appointment_provider.dart**: 📆 Manage appointment state.
  - **payment_provider.dart**: 💸 Manage payment state.
- **lib/services/firebase_service.dart**: ⚡️ Interact with Firebase.

---

## Firebase Integration

The project uses Firebase for:
- **🔐 Authentication:** Secure user login and registration.
- **📆 Firestore:** Real-time database operations.

### Configuration:
Ensure the necessary Firebase configuration files (`google-services.json` for Android) are in place. Follow Firebase setup guidelines for Flutter projects.

---

## Firebase Secrets

To keep your Firebase secrets secure, create a `secret.dart` file in the project and define your Firebase credentials as follows:

```dart
class Secret {
  static const String apiKey = 'API_KEY';
  static const String appId = 'APP_ID';
  static const String messagingSenderId = 'YOUR_MESSAGING_SENDER_ID';
  static const String projectId = 'YOUR_PROJECT_ID';
}
```

Make sure to replace the placeholders (`API_KEY`, `APP_ID`, etc.) with your actual Firebase project credentials. Add `secret.dart` to your `.gitignore` file to prevent it from being committed to version control.

---

## Testing the Application

To see the waiting list feature in action:
1. 📅 Schedule an appointment for the current date using one patient account.
2. 📊 Add another appointment for the same day using a different patient account.

### Credentials for Testing

- **Admin:**
  - Email: `admin@gmail.com`
  - Password: `admin123`

- **Doctor:**
  - Email: `doctor@gmail.com`
  - Password: `doctor123`

- **Patients:**
  - Patient 1:
    - Email: `ptzero@gmail.com`
    - Password: `patient123`
  - Patient 2:
    - Email: `ptone@gmail.com`
    - Password: `patient123`

---

## APK Download

🔄 [Download the APK](https://drive.google.com/file/d/1-Gb9WXl4rBJh1LnxRNard5GzfybGOpmV/view?usp=sharing)
