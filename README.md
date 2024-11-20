# Offers App

## Overview
Offers App is an innovative mobile application built with Flutter that helps users discover, filter, and redeem the best offers around them. By incorporating location-based filtering, QR scanning, and gamification elements, the app makes finding and using offers a rewarding experience.

## How to run: 

### Firebase Setup

This application uses **Firebase** for backend services such as authentication, database, and analytics. To set up Firebase for this project automatically, follow these steps:



**Step 1: Install the Firebase CLI**
If you don't already have it installed, run:
```
npm install -g firebase-tools
```



**Step 2: Log in to your Firebase account**
Authenticate your Firebase CLI with your Google account:
```
firebase login
```



**Step 3: Initialize Firebase in the project**
Run the following command in the project directory:
```
firebase init
```


During the setup:
- Select your Firebase project or create a new one.
- Choose the services you want to use (e.g., Firestore, Authentication, etc.).


**Step 4: Configure Firebase with the FlutterFire CLI**
Run the FlutterFire CLI command to set up the project:
```
flutterfire configure
```

This will:
- Set up the Firebase project for your Flutter app.
- Generate the firebase_options.dart file inside the lib/ folder.
- Download the required Firebase configuration files:
- google-services.json for Android (saved in android/app/).





### You will need a Google Maps API key
1. Create a .env file in the root directory of the project (next to pubspec.yaml).

2. Add your Google Maps API Key to the .env file in the following format:
GOOGLE_MAPS_API_KEY=your_real_google_maps_api_key

**Note: The .env file is already included in .gitignore for security reasons.**
The API key is dynamically loaded into AndroidManifest.xml during the build process via BuildConfig.

3. After setting up the .env file run:

```
flutter clean
```
```  
flutter pub get
```
