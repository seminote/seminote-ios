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

## 🧪 Testing & Quality Assurance

### Unit Testing
```swift
// Tests/SeminoteTests/AudioProcessingTests.swift
import XCTest
@testable import Seminote

class AudioProcessingTests: XCTestCase {
    var audioProcessor: AudioProcessor!
    
    override func setUp() {
        super.setUp()
        audioProcessor = AudioProcessor()
    }
    
    func testAudioBufferProcessing() {
        let testBuffer = generateTestAudioBuffer()
        let result = audioProcessor.processBuffer(testBuffer)
        
        XCTAssertNotNil(result)
        XCTAssertLessThan(result.processingLatency, 5.0) // <5ms requirement
    }
    
    func testNoteDetection() {
        let pianoNote = generatePianoNote(frequency: 440.0) // A4
        let detectedNote = audioProcessor.detectNote(pianoNote)
        
        XCTAssertEqual(detectedNote.pitch, .A)
        XCTAssertEqual(detectedNote.octave, 4)
        XCTAssertGreaterThan(detectedNote.confidence, 0.8)
    }
}
```

### Performance Testing
```swift
// Tests/SeminoteTests/PerformanceTests.swift
class PerformanceTests: XCTestCase {
    func testAudioProcessingPerformance() {
        let audioProcessor = AudioProcessor()
        let testBuffer = generateTestAudioBuffer()
        
        measure {
            _ = audioProcessor.processBuffer(testBuffer)
        }
        // Should complete in <5ms for local processing
    }
    
    func testMLModelInference() {
        let mlModel = LocalMLModel()
        let features = generateTestFeatures()
        
        measure {
            _ = mlModel.predict(features)
        }
        // Should complete in <2ms for note detection
    }
}
```

## 🚀 Performance Optimization

### Audio Processing Optimization
```swift
// Core/Audio/OptimizedAudioProcessor.swift
class OptimizedAudioProcessor {
    private let audioQueue = DispatchQueue(label: "audio.processing", qos: .userInteractive)
    private let circularBuffer = CircularBuffer<Float>(capacity: 4096)
    
    func processAudioRealTime(_ buffer: AVAudioPCMBuffer) {
        audioQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Zero-copy buffer processing
            let channelData = buffer.floatChannelData![0]
            let frameCount = Int(buffer.frameLength)
            
            // SIMD-optimized processing
            self.processWithSIMD(channelData, frameCount: frameCount)
        }
    }
    
    private func processWithSIMD(_ data: UnsafeMutablePointer<Float>, frameCount: Int) {
        // Use Accelerate framework for SIMD operations
        var result = [Float](repeating: 0, count: frameCount)
        vDSP_vadd(data, 1, data, 1, &result, 1, vDSP_Length(frameCount))
    }
}
```

## 📱 Device Compatibility

### Minimum Requirements
- **iOS Version**: 15.0+
- **Device**: iPhone 8 / iPad (6th generation) or newer
- **RAM**: 3GB minimum, 4GB+ recommended
- **Storage**: 500MB for app + models
- **Audio**: Built-in microphone or external audio interface

### Optimized Performance
- **iPhone 12 Pro and newer**: Full feature set with <3ms latency
- **iPad Pro with M1/M2**: Enhanced ML processing capabilities
- **External Audio Interfaces**: Professional-grade latency <1ms
