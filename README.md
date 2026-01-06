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

