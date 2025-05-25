# Seminote iOS App

🎹 **iOS mobile application with local ML processing capabilities for ultra-low latency piano feedback (<5ms) and offline practice functionality**

## Overview

The Seminote iOS app is the primary client application for the Seminote Piano Learning Platform, featuring innovative **speed-adaptive hybrid architecture** that intelligently switches between local ML processing and edge computing based on playing speed and context.

### Key Features

- ⚡ **Ultra-Low Latency**: <5ms feedback for fast playing (>120 BPM) using local ML models
- 🤖 **Local ML Processing**: On-device Core ML models for basic note detection and rhythm analysis
- 📱 **Offline Capability**: Full practice functionality without internet connectivity
- 🌐 **Edge Integration**: WebRTC streaming to edge services for detailed analysis during slow practice
- 🎯 **Adaptive Learning**: Personalized curriculum that adapts to user skill level and playing speed
- 🔒 **Privacy-First**: Audio processing stays local for fast playing sessions

## Architecture

### Speed-Adaptive Processing Modes

1. **Fast Playing Mode (>120 BPM)**
   - Local iOS ML processing
   - <5ms latency feedback
   - Basic note detection and rhythm analysis
   - Background session recording for later analysis

2. **Slow Practice Mode (<60 BPM)**
   - Edge ML processing via WebRTC
   - 10-20ms latency for detailed feedback
   - Advanced polyphonic transcription
   - Note-by-note corrections and suggestions

3. **Hybrid Mode (60-120 BPM)**
   - Combined local + edge processing
   - Basic real-time feedback + detailed phrase analysis
   - Progressive learning experience

4. **Offline Mode**
   - 100% local processing
   - Full practice functionality
   - Smart sync when connectivity restored

## Technology Stack

### Core iOS Technologies
- **Swift 5.9+** - Primary development language
- **SwiftUI** - Modern declarative UI framework
- **UIKit** - Traditional UI components where needed
- **Xcode 15+** - Development environment

### Audio & ML Frameworks
- **AVFoundation** - Audio capture and processing
- **Core ML** - On-device machine learning
- **Core Audio** - Low-level audio processing
- **AudioKit** - High-level audio synthesis
- **WebRTC iOS** - Real-time edge communication

### Data & Storage
- **Core Data** - Local data persistence
- **SQLite** - Lightweight database
- **UserDefaults** - Simple key-value storage
- **Keychain** - Secure credential storage

### Networking & Communication
- **Network Framework** - Modern networking
- **Combine** - Reactive programming
- **WebSocket** - Real-time communication
- **URLSession** - HTTP networking

## Project Status

- **Current Phase**: Requirements Phase (Sprint 1 - Foundation)
- **Target Release**: Q4 2025
- **Team Size**: 8 members
- **Architecture Status**: Speed-adaptive hybrid design finalized

## Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0+ deployment target
- macOS 14.0+ for development
- Apple Developer account for device testing

### Installation
```bash
# Clone the repository
git clone https://github.com/seminote/seminote-ios.git
cd seminote-ios

# Install dependencies (when available)
# Swift Package Manager dependencies will be resolved automatically in Xcode
```

### Development Setup
1. Open `Seminote.xcodeproj` in Xcode
2. Select your development team in project settings
3. Choose target device or simulator
4. Build and run the project

## Project Structure

```
seminote-ios/
├── Seminote/                          # Main app target
│   ├── App/                          # App lifecycle and configuration
│   ├── Core/                         # Core business logic
│   │   ├── Audio/                    # Audio processing and capture
│   │   ├── ML/                       # Local ML models and processing
│   │   ├── Network/                  # Networking and API clients
│   │   └── Storage/                  # Data persistence layer
│   ├── Features/                     # Feature modules
│   │   ├── Authentication/           # User authentication
│   │   ├── Learning/                 # Learning and practice features
│   │   ├── Practice/                 # Practice session management
│   │   ├── Progress/                 # Progress tracking and analytics
│   │   └── Settings/                 # App settings and preferences
│   ├── UI/                          # User interface components
│   │   ├── Components/              # Reusable UI components
│   │   ├── Screens/                 # Screen implementations
│   │   └── Themes/                  # Design system and themes
│   └── Resources/                   # Assets, localizations, etc.
├── SeminoteTests/                   # Unit tests
├── SeminoteUITests/                 # UI tests
├── SeminoteWatch/                   # Apple Watch companion app (future)
└── Shared/                         # Shared code between targets
```

## Development Guidelines

### Code Style
- Follow Swift API Design Guidelines
- Use SwiftLint for code style enforcement
- Implement comprehensive unit tests
- Document public APIs with Swift documentation

### Architecture Patterns
- **MVVM** with Combine for reactive programming
- **Repository Pattern** for data access
- **Dependency Injection** for testability
- **Protocol-Oriented Programming** for flexibility

### Performance Requirements
- **Audio Latency**: <5ms for local processing
- **App Launch**: <2 seconds cold start
- **Memory Usage**: <100MB during normal operation
- **Battery Life**: Minimal impact during practice sessions

## Contributing

This project is currently in the foundation phase. Development guidelines and contribution processes will be established as the project progresses.

## License

Copyright © 2024-2025 Seminote. All rights reserved.

---

**Part of the Seminote Piano Learning Platform**
- 🎹 [iOS App](https://github.com/seminote/seminote-ios) (this repository)
- ⚙️ [Backend Services](https://github.com/seminote/seminote-backend)
- 🌐 [Real-time Services](https://github.com/seminote/seminote-realtime)
- 🤖 [ML Services](https://github.com/seminote/seminote-ml)
- 🚀 [Edge Services](https://github.com/seminote/seminote-edge)
- 🏗️ [Infrastructure](https://github.com/seminote/seminote-infrastructure)
- 📚 [Documentation](https://github.com/seminote/seminote-docs)
