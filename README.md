# Mobile Application Development Project for COMP3130

## Laptop Deals Application

### Overview
Laptop Deals is a mobile application designed to help users discover, compare, and share laptop deals. The application serves as a community-driven platform where users can post and browse laptop deals, complete with detailed specifications and pricing information.

### Target Audience
- Tech-savvy consumers looking for laptop deals
- Students and professionals seeking budget-friendly laptop options
- Tech enthusiasts who want to share and discover laptop deals
- Users who want to compare laptop specifications and prices

### Main Functionality
1. **User Authentication**
   - Login and registration system
   - Sign-out functionality

2. **Deal Management**
   - Post new laptop deals with detailed specifications
   - Browse existing deals
   - Save favorite deals for later reference

3. **Specification Details**
   - Comprehensive laptop specifications including:
     - Brand
     - CPU details
     - GPU information
     - RAM capacity
     - Screen size and refresh rate
     - Price
     - Images

4. **User Interface**
   - Bottom navigation bar for easy access to main features
   - Intuitive deal posting form with image upload capability

### Design Evolution from Deliverable 1
The final implementation includes several enhancements from the initial design:
1. Added image upload functionality for laptop deals
2. Implemented a more robust search system
3. Improved the navigation system with a bottom navigation bar
4. Adding user authentication and user maangement in system using firebase
5. Allowing user to upload and share their deals to the system

### Development and Testing
The application has been developed and tested on the following devices:
- **Android Devices:**
  - Oneplus 13 (Android 15) 
  - Google Pixel 6 (Android 15)
  - Work out of the box, no issue detected
- **Windows Devices**
  - Work with most Windows devices
- **Linux Devices**:
  - Firebase authenticationa and storage does not work with Linux system.
- **Web Browser**:
  - Chrome
  - Edge
  - All Web Browser work out of the box.

### Technical Implementation
- Built using Flutter framework
- Firebase integration for:
  - Authentication
  - Cloud Firestore database
  - Cloud Storage for images
- State management using Riverpod instead of tradiditonal Provider since Riverpod are well better maintenance, with built-in error handling with AsyncValue type, realtime data tracking. Provide better flexibility and easier to work with
- Material Design 3 theming

### Additional Notes for Markers
1. **Authentication:**
   - The app uses Firebase Authentication
   - Test accounts are available in the application documentation

2. **Database:**
   - Cloud Firestore is used for data storage
   - The database structure is optimized for real-time updates using state management with Riverpod

3. **Image Storage:**
   - Images are stored in Firebase Storage
   - Implemented with proper security rules

4. **Performance Considerations:**
   - Implemented loading for images
   - Efficient state management

5. **Known Limitations:**
   - Image upload database is limited
   - Offline functionality is limited
   - Some advanced search features are pending implementation
   - Status and data tracking with each user are still progress of implementation
   - User account management and customization will be implemented in future.

### Setup Instructions
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure Firebase:
   - Add your Firebase configuration files
   - Enable Authentication, Firestore, and Storage
4. Run the application using `flutter run`
5. Test Account for testing:
   - account: test@gmail.com
   - password: 123456

### Dependencies
Key dependencies are listed in the `pubspec.yaml` file, including:
- firebase_core
- firebase_auth
- cloud_firestore
- flutter_riverpod
- image_picker
- firebase_storage
