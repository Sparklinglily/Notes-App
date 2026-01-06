# Notes App

A clean architecture notes application built with Flutter, Firebase, and Riverpod.

##  Features Implemented

### Authentication 

- Email/Password Sign Up
- Email/Password Login
- Logout functionality
- Session persistence (user stays logged in after app restart)
- Firebase Authentication integration

### Notes Management (CRUD)
- Create notes
- Read/View notes
- Update/Edit notes
- Delete notes
- Real-time updates from Firestore
- User-specific notes (users can only see their own notes)

### Search Functionality (Additional Requirement - Option B)

- Search notes by title
- Real-time search with instant results
- Clear search functionality

### UI Design

- Indigo & Purple color scheme
- Smooth animations and transitions
- Responsive layouts
- Loading states and error handling
- Empty states with helpful messages


## Project Structure


```
lib/
├── core/
│   ├── constants/       # App-wide constants (colors, strings)
│   ├── errors/          # Error handling (failures)
│   └── utils/           # Utility functions (validators)
├── data/
│   ├── service/     # Firebase service
│   ├── models/          # Data models
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business logic
└── presentation/
    ├── providers/       # Riverpod state management
    ├── screens/         # UI screens
    └── widgets/         # Reusable widgets

```

## Design Pattern : MVVM

- Model: Domain entities and data models for modularity
- View:Flutter widgets and screens
- ViewModel: Riverpod providers managing state

##  Firebase Setup

###  Database Schema => Firestore Collection (notes)


```
notes/
└── {noteId}/
    ├── id: String
    ├── title: String
    ├── content: String
    ├── userId: String
    ├── createdAt: Timestamp
    └── updatedAt: Timestamp
```
## Firestore Security Rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{noteId} {
      // Users can only read their own notes
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      
      // Users can only create notes with their own userId
      allow create: if request.auth != null && 
                       request.resource.data.userId == request.auth.uid;
      
      // Users can only update their own notes
      allow update: if request.auth != null && 
                       resource.data.userId == request.auth.uid;
      
      // Users can only delete their own notes
      allow delete: if request.auth != null && 
                       resource.data.userId == request.auth.uid;
    }
  }
}
```

## Firebase Authentication

Email/Password authentication enabled for both login ad sign up
User sessions persisted automatically by Firebase

## Setup Instructions

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- Firebase account
- Android device or emulator

## Step 1: Clone the Repository

git clone <your-repository-url>
cd notes_app

## Step 2: Install Dependencies 

flutter pub get

## Step 3: Firebase Configuration

1. Create a Firebase Project

- Go to Firebase Console
- Create a new project or use an existing one
- Add an Android app to your Firebase project


2. Register Your Android App

- Package name: com.example.notes_app
- Download google-services.json
- Place it in android/app/ directory


3. Enable Authentication

- Go to Firebase Console > Authentication
- Enable Email/Password sign-in method


4. Create Firestore Database

- Go to Firebase Console > Firestore Database
- Create database in production mode
- Apply the security rules provided above


5. Update Firestore Indexes (if needed)

- The app uses orderBy('updatedAt', descending: true)
- Firebase will prompt you to create an index if needed

## Step 4: Run the App

```bash
flutter doctor

flutter pub get

flutter run

flutter build apk --release
```

The APK will be located at: build/app/outputs/flutter-apk/app-release.apk

## Security Implementation

### User Isolation

- Each note contains a userId field
- Firestore security rules enforce user-specific access
- Users cannot see, edit, or delete other users' notes

## Authentication Flow

1. User signs up/logs in
2. Firebase generates a unique uid
3. All notes are created with the user's uid
4. Queries filter by userId for security
5. Firestore rules provide backend security


## Screens

1. Splash Screen: Initial loading and auth check
2. Login Screen: Email/password login
3. Signup Screen: New account creation
4. Notes List: Display all user notes with search
5. Note Detail: View note with edit/delete options
6. Add/Edit Note: Create or modify notes

## Assumptions & Trade-offs

### Assumptions

- Users have internet connectivity for Firebase operations
- Email/password is sufficient for authentication
- Simple note structure (title + content) is adequate
- Search by title only is sufficient atleast for version 1

### Trade-offs

- Clean Architecture: Adds more boilerplate but ensures maintainability and follows the SOLID principle
- Firebase: Vendor lock-in but allows for rapid development and saves cost.
- Client-side Search: Simple implementation, scales to thousands of notes
- No offline mode: Due to the simplicity of the assignment scope

## Known Limitations

1. No offline support: Requires active internet connection
2. Email-only auth: No social logins or phone authentication
3. Basic search: Only searches note titles, not content
4. No note sharing: Notes are private to each user

##  Building APK

### Debug APK

```bash

flutter build apk --debug

```

### Release APK (Recommended for submission)

```bash

flutter build apk --release

```


## Code Quality

### Clean Code Principles

- Single Responsibility Principle
- Dependency Inversion
- Separation of Concerns
- DRY (Don't Repeat Yourself)

### Error Handling

- Robust try-catch blocks
- User-friendly error messages
- Smooth failure states

### State Management

- Reactive programming with Riverpod
- Immutable state objects
- Clean state updates


## Developed with Clean Architecture, MVVM, and Riverpod 
## Firebase Auth & Firestore Backend and Material Design 3 UI




