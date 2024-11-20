# **Offers App**

## **Overview**
Offers App is an innovative mobile application built with Flutter that helps users discover, filter, and redeem the best offers around them. By incorporating location-based filtering, QR scanning, and gamification elements, the app makes finding and using offers a rewarding experience.

## **How to run:** 

1. Create a .env file in the root directory of the project (next to pubspec.yaml).

2. Add your Google Maps API Key to the .env file in the following format:
GOOGLE_MAPS_API_KEY=your_real_google_maps_api_key

**Note: The .env file is already included in .gitignore for security reasons.**
The API key is dynamically loaded into AndroidManifest.xml during the build process via BuildConfig.

3. After setting up the .env file run:

        flutter clean

        flutter pub get
