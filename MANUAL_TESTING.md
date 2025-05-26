# 🧪 Manual Testing Guide

This guide provides comprehensive manual testing procedures for the Seminote iOS development environment and application functionality.

## 📋 Table of Contents

- [Quick Testing Checklist](#quick-testing-checklist)
- [Development Environment Testing](#development-environment-testing)
- [iOS Simulator Testing](#ios-simulator-testing)
- [Audio Processing Testing](#audio-processing-testing)
- [ML Model Testing](#ml-model-testing)
- [CI/CD Pipeline Testing](#cicd-pipeline-testing)
- [Performance Testing](#performance-testing)
- [Troubleshooting](#troubleshooting)

## ✅ Quick Testing Checklist

### Essential Tests (5 minutes)
```bash
# 1. Environment validation
swift --version
xcodebuild -version

# 2. Build verification
swift build

# 3. Test execution
swift test

# 4. iOS Simulator test
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4'
```

**Expected Results:**
- ✅ Swift 6.1+ detected
- ✅ Xcode 16.3+ detected  
- ✅ All modules build successfully
- ✅ All 17 tests pass

## 🔧 Development Environment Testing

### 1. Xcode Version Verification
```bash
# Check Xcode version
xcodebuild -version

# Expected output:
# Xcode 16.3
# Build version 16D5024a
```

### 2. iOS SDK Availability
```bash
# List available SDKs
xcodebuild -showsdks | grep ios

# Expected output should include:
# iOS 18.4                      -sdk iphoneos18.4
```

### 3. Swift Package Manager
```bash
# Verify package resolution
swift package describe

# Check dependencies
swift package show-dependencies
```

### 4. Git Configuration
```bash
# Verify git is working
git status
git log --oneline -5
```

## 📱 iOS Simulator Testing

### 1. Available Simulators
```bash
# List available simulators
xcrun simctl list devices available

# Look for:
# iPhone 16 Pro (iOS 18.4)
# iPhone 15 Pro (iOS 18.4)
# iPad Pro (12.9-inch) (6th generation) (iOS 18.4)
```

### 2. Primary Testing Command
```bash
# Main testing command (recommended)
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4'
```

**Expected Test Results:**
```
Test Suite 'All tests' started
Test Suite 'SeminotePackageTests.xctest' started
Test Suite 'DevelopmentEnvironmentTests' started

✅ testXcodeVersion - Xcode 15+ compatibility verified
✅ testIOSSDKVersion - iOS SDK version validation
✅ testCoreMLAvailability - Core ML framework available
✅ testMLModelLoading - ML models loading process completed
✅ testMLProcessingPerformance - ML processing performance measured
✅ testDeviceMLCapabilities - Device capabilities assessed
✅ testAVFoundationAvailability - AVFoundation framework available
✅ testAudioSessionConfiguration - Audio session configuration
✅ testMicrophoneAvailability - Microphone availability
✅ testAudioBufferConfiguration - Audio buffer configuration validated
✅ testAudioEngineInitialization - Audio engine initialized
✅ testBundleIdentifier - Bundle identifier validation
✅ testAppPermissions - App permissions configured
✅ testBackgroundModes - Background modes validation
✅ testAudioProcessingLatency - Audio processing latency measured
✅ testMemoryUsage - Memory usage validation
✅ testFullAudioMLPipeline - Full audio-ML pipeline tested

Executed 17 tests, with 0 failures
```

### 3. Multi-Device Testing
```bash
# Test on different devices
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 15,OS=18.4'
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch) (6th generation),OS=18.4'
```

### 4. Verbose Testing
```bash
# Detailed test output
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4' -verbose
```

## 🎹 Audio Processing Testing

### 1. Audio Engine Initialization
**Test Steps:**
1. Run the audio engine initialization test
2. Verify no errors in console
3. Check audio session configuration

```bash
# Specific audio test
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4' -only-testing:SeminoteTests/DevelopmentEnvironmentTests/testAudioEngineInitialization
```

**Expected Output:**
```
✅ Audio engine initialized
✅ Audio session configuration test skipped on macOS
```

### 2. Audio Latency Testing
```bash
# Performance test
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4' -only-testing:SeminoteTests/DevelopmentEnvironmentTests/testAudioProcessingLatency
```

**Expected Results:**
- ✅ Latency measurements completed
- ✅ Processing time under acceptable thresholds

### 3. Audio Buffer Configuration
```bash
# Buffer test
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4' -only-testing:SeminoteTests/DevelopmentEnvironmentTests/testAudioBufferConfiguration
```

## 🧠 ML Model Testing

### 1. Core ML Availability
```bash
# ML framework test
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4' -only-testing:SeminoteTests/DevelopmentEnvironmentTests/testCoreMLAvailability
```

### 2. ML Processing Performance
```bash
# Performance test
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4' -only-testing:SeminoteTests/DevelopmentEnvironmentTests/testMLProcessingPerformance
```

### 3. Device ML Capabilities
```bash
# Capabilities test
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4' -only-testing:SeminoteTests/DevelopmentEnvironmentTests/testDeviceMLCapabilities
```

**Expected Output:**
```
📱 Device Capabilities:
   - Processor Cores: 10
   - Physical Memory: 16384MB
✅ Device capabilities assessed
```

## 🚀 CI/CD Pipeline Testing

### 1. Local Pipeline Simulation
```bash
# Simulate CI/CD steps locally
echo "🔧 Simulating CI/CD Pipeline..."

# Step 1: Code Quality (SwiftLint)
if command -v swiftlint >/dev/null 2>&1; then
    echo "✅ Running SwiftLint..."
    swiftlint --quiet
else
    echo "⚠️ SwiftLint not installed (optional for local testing)"
fi

# Step 2: Build
echo "✅ Building project..."
swift build

# Step 3: Test
echo "✅ Running tests..."
swift test

# Step 4: iOS Simulator Test
echo "✅ Running iOS Simulator tests..."
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4' -quiet

echo "🎉 Local CI/CD simulation complete!"
```

### 2. GitHub Actions Status Check
```bash
# Check latest pipeline status
gh run list --limit 5

# View specific run details
gh run view [run-id]
```

## ⚡ Performance Testing

### 1. Memory Usage Testing
```bash
# Memory test
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4' -only-testing:SeminoteTests/DevelopmentEnvironmentTests/testMemoryUsage
```

### 2. Full Pipeline Testing
```bash
# Complete pipeline test
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4' -only-testing:SeminoteTests/DevelopmentEnvironmentTests/testFullAudioMLPipeline
```

### 3. Build Performance
```bash
# Measure build time
time swift build

# Clean build measurement
swift package clean
time swift build
```

## 🔍 Troubleshooting

### Common Issues and Solutions

#### 1. "No such module" Errors
```bash
# Solution: Clean and rebuild
swift package clean
swift package resolve
swift build
```

#### 2. Simulator Not Found
```bash
# List available simulators
xcrun simctl list devices available

# Use exact name from list
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=[EXACT_NAME],OS=18.4'
```

#### 3. Test Failures
```bash
# Run specific failing test
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4' -only-testing:SeminoteTests/DevelopmentEnvironmentTests/[TEST_NAME]

# Run with verbose output
xcodebuild test -scheme Seminote -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.4' -verbose
```

#### 4. Audio Permission Issues
- iOS Simulator has limited audio capabilities
- Some audio tests may be skipped on macOS
- Use physical device for full audio testing

#### 5. Xcode License Issues
```bash
# Accept Xcode license
sudo xcodebuild -license accept
```

## 📊 Test Results Interpretation

### Success Indicators
- ✅ All 17 tests pass
- ✅ Build completes without errors
- ✅ No memory leaks detected
- ✅ Performance metrics within acceptable ranges

### Warning Indicators
- ⚠️ Some tests skipped on macOS (expected)
- ⚠️ Audio tests limited in simulator (expected)
- ⚠️ SwiftLint warnings (non-blocking)

### Failure Indicators
- ❌ Build failures
- ❌ Test failures
- ❌ Memory usage exceeding limits
- ❌ Performance degradation

## 🎯 Testing Best Practices

1. **Run tests frequently** during development
2. **Use iOS Simulator** for comprehensive testing
3. **Test on multiple devices** when possible
4. **Monitor performance metrics** regularly
5. **Keep dependencies updated** via Swift Package Manager
6. **Validate CI/CD pipeline** before pushing changes

---

**Next Steps:** After successful manual testing, proceed with iOS app development using the validated environment.
