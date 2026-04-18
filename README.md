# PixVault 🌌

A premium, production-ready Flutter mobile application for secure and esthetic gallery management. Built with the **"Velvet Archive"** design system.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.32.8-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Auth-FFCA28?logo=firebase)

## ✨ Features

- **Premium UI**: "Velvet Archive" dark theme with vibrant violet gradients.
- **Secure Auth**: Integrated with Firebase Authentication (Email/Password).
- **Custom Navigation**: Aesthetic Bottom Navigation with a center FAB for uploads.
- **Storage Insights**: Animated circular storage ring tracking your vault capacity.
- **Masonry Gallery**: Staggered grid view for a modern photo browsing experience.
- **Pinch-to-Zoom**: High-performance image viewing with full zoom support.
- **ImgBB Integration**: Simultaneous and concurrent image uploads to ImgBB cloud.

## 🚀 Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: `flutter_bloc` (Cubit pattern)
- **Navigation**: `go_router`
- **Database**: `Hive` (Local Cache & Metadata)
- **Networking**: `Dio`
- **Analytics/Backend**: `Firebase`

## 🛠️ Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/whyptr17/PixVault.git
   cd PixVault
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:
   - Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
   - Configure: `flutterfire configure --project=your-project-id`

4. **Run the app**:
   ```bash
   flutter run --dart-define=IMGBB_API_KEY=your_api_key_here
   ```

## 🏗️ CI/CD

This project uses **GitHub Actions** to automatically build the release APK. 
Remember to add `IMGBB_API_KEY` to your **GitHub Repository Secrets** to ensure successful builds.

---
Built with ❤️ for memories that matter.
