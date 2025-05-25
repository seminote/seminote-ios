# Audio Processing Module

Core audio processing capabilities for ultra-low latency piano feedback.

## Key Components

- `AudioEngine.swift` - Main audio processing engine
- `AudioCapture.swift` - Real-time audio capture
- `LocalMLProcessor.swift` - On-device ML audio analysis
- `AudioBuffer.swift` - Audio buffer management
- `LatencyOptimizer.swift` - Latency optimization utilities

## Features

- **Ultra-low latency**: <5ms processing for fast playing
- **Real-time capture**: High-quality audio input
- **Local ML processing**: On-device note detection
- **Background recording**: Session recording for analysis
- **Adaptive quality**: Quality adjustment based on device capabilities

## Performance Targets

- Audio latency: <5ms
- CPU usage: <20% during normal operation
- Memory usage: <50MB for audio buffers
- Battery impact: Minimal during practice sessions
