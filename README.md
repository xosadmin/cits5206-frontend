# AI-Driven Podcast Knowledge Capture App - AudioPin
  
## Project Overview
**AudioPin** is an AI-driven podcast knowledge capture app designed to solve a common issue for podcast listeners-capturing valuable insights from podcasts and organizing them for future reference.
It provides a solution by allowing users to effortlessly record audio snippets and attach personalized notes for context, creating a powerful system to retain and organize knowledge from podcasts. The app is cross-platform, ensuring users can enjoy a consistent experience on both iOS and Android devices. With AudioPin, podcast listeners can easily revisit their favorite moments and take their learning to the next level.
## Features
1. Signup/Login
   * User authentication functionality that allows users to create accounts or log in to the app.
2. Default Podcast Categories
   * Displays default categories of podcasts on the homepage for easy navigation and discovery.
3. Search for Podcasts
   * A search functionality that enables users to find podcasts based on keywords, categories, or other filters.
4. Mini Player
   * A mini player that allows users to control playback without leaving the current screen.
5. Audio Snippet Capture
   * Allows users to capture specific segments of a podcast audio for future reference. 
6. Make a note
   * Provides users with the ability to attach notes to audio snippets for contextual organization.
7. Podcast Player
   * A full-featured podcast player for listening to and controlling podcast playback.
8. Change settings
   * Allow users to change general settings and profile settings. 
9. Library functions
   * Allow users to view and access notes and podcasts in library.
## Setup Preperation
Before starting, please ensure your system meets the following requirements:
* Operating System: macOS or Windows
* Flutter SDK: Flutter 3.0.0 or above
* Dart SDK: Included with the Flutter SDK
## Installation
**Install Flutter SDK**
1. Visit the [Flutter website](https://docs.flutter.dev/).
2. Choose the installation package based on your operating system and follow the instructions in the documentation.
3. Configure the environment variables:
   * macOS:
   
   ```export PATH="$PATH:`flutter_path`/bin"```
   * Windows: Add the bin directory of Flutter to your system's PATH.
4. Verify the installation by running:

   ```flutter doctor```

This command will check if all dependencies are correctly installed.

**Install Development Tools**
1. iOS Environment:
   * Install Xcode and configure the command-line tools:
  
   ```sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer```

   * Ensure CocoaPods is installed:
  
   ```sudo gem install cocoapods```
3. Android Environment:
   * Install Android Studio and ensure the Flutter and Dart plugins are installed.
   * Configure the Android SDK path, and make sure the required virtual devices are enabled for debugging.
  
**Initialize the Project**
1. Clone the project repository:

   ```git clone https://github.com/xosadmin/cits5206-frontend```
   
   ```cd <project-directory>```
2. Install project dependencies:
   
   ```flutter pub get```

**Run the Project**
* Running on iOS Simulator:
  1. Open Xcode and select the iOS simulator from the project.
  2. Run the following command to start the iOS simulator and compile the app:

     ```flutter run```
     
* Running on Android Emulator:
  1. Open Android Studio and start the virtual device.
  2. Use the following command to launch the project:

     ```flutter run```
     
## About the Developers
| Student Number | Student Name | Role | Github Account |
| :----:| :----: | :----: | :----: |
| 23877677 | Chen Shen | Backend | jerryshenfewcher |
| 23877962 | Jikang Song | Backend | jikang1116 |
| 23885505 | Hanxun Xu | Backend | xosadmin |
| 23904899 | Wendy Wang | Frontend | akikodesu |
| 23825634 | Yunwei Zhang | Frontend | Yunwei-Zhang |
| 23876142 | Nishanth Arul | Frontend | NishanthArul |

## References
* [Flutter Official Documentation](https://docs.flutter.dev/)
* [iOS Development Guide](https://docs.flutter.dev/get-started/install/macos/mobile-ios)
* [Android Development Guide](https://docs.flutter.dev/get-started/install/windows/mobile)
