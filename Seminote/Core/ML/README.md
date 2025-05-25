# Machine Learning Module

Local ML processing for real-time piano analysis and feedback.

## Core ML Models

- `NoteDetectionModel.mlmodel` - Basic note detection (5MB)
- `OnsetDetectionModel.mlmodel` - Note onset detection (3MB)
- `RhythmAnalysisModel.mlmodel` - Rhythm analysis (7MB)
- `VolumeDetectionModel.mlmodel` - Volume analysis (2MB)

## Key Components

- `MLModelManager.swift` - Model loading and management
- `NoteDetector.swift` - Real-time note detection
- `RhythmAnalyzer.swift` - Rhythm analysis
- `ModelUpdater.swift` - Background model updates
- `PerformanceOptimizer.swift` - ML performance optimization

## Features

- **Local processing**: All models run on-device
- **Model updates**: Background model synchronization
- **Adaptive inference**: Performance-based model selection
- **Offline capability**: Full functionality without internet

## Performance Requirements

- Inference time: <2ms per audio frame
- Model size: <15MB total
- Memory usage: <30MB during inference
- CPU usage: <15% during normal operation
