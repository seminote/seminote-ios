#!/bin/bash

# Seminote iOS Development Environment Test Script
# This script validates the iOS development setup and runs comprehensive tests

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
XCODE_VERSION="15.0"
IOS_VERSION="17.0"
SIMULATOR_NAME="iPhone 15 Pro"
SCHEME_NAME="Seminote"

echo -e "${BLUE}🚀 Starting Seminote iOS Development Environment Tests${NC}"
echo "=================================================="

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
        exit 1
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Test 1: Check Xcode installation
echo -e "\n${BLUE}1. Checking Xcode Installation${NC}"
echo "--------------------------------"

if command -v xcodebuild &> /dev/null; then
    XCODE_CURRENT=$(xcodebuild -version | head -n 1 | awk '{print $2}')
    echo "Xcode version: $XCODE_CURRENT"
    print_status 0 "Xcode is installed"
else
    print_status 1 "Xcode is not installed"
fi

# Test 2: Check iOS SDK
echo -e "\n${BLUE}2. Checking iOS SDK${NC}"
echo "-------------------"

SDK_LIST=$(xcodebuild -showsdks | grep iphoneos)
if echo "$SDK_LIST" | grep -q "iphoneos17"; then
    print_status 0 "iOS 17+ SDK is available"
else
    print_warning "iOS 17+ SDK not found, but continuing with available SDK"
fi

# Test 3: Check Swift Package Manager
echo -e "\n${BLUE}3. Testing Swift Package Manager${NC}"
echo "--------------------------------"

if [ -f "Package.swift" ]; then
    print_info "Resolving Swift Package dependencies..."
    swift package resolve
    print_status $? "Swift Package dependencies resolved"
    
    print_info "Validating Package.swift..."
    swift package dump-package > /dev/null
    print_status $? "Package.swift is valid"
else
    print_status 1 "Package.swift not found"
fi

# Test 4: Check project structure
echo -e "\n${BLUE}4. Validating Project Structure${NC}"
echo "-------------------------------"

required_files=(
    "Seminote/App/SeminoteApp.swift"
    "Seminote/App/ContentView.swift"
    "Seminote/App/Info.plist"
    "Seminote/Core/Audio/AudioEngine.swift"
    "Seminote/Core/ML/MLProcessor.swift"
    "SeminoteTests/DevelopmentEnvironmentTests.swift"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        print_status 0 "$file exists"
    else
        print_status 1 "$file is missing"
    fi
done

# Test 5: Check simulators
echo -e "\n${BLUE}5. Checking iOS Simulators${NC}"
echo "---------------------------"

SIMULATORS=$(xcrun simctl list devices available | grep "iPhone\|iPad")
if [ -n "$SIMULATORS" ]; then
    print_status 0 "iOS Simulators are available"
    echo "Available simulators:"
    echo "$SIMULATORS" | head -5
else
    print_status 1 "No iOS Simulators found"
fi

# Test 6: Build project
echo -e "\n${BLUE}6. Building Project${NC}"
echo "-------------------"

print_info "Building for iOS Simulator..."
xcodebuild build \
    -scheme "$SCHEME_NAME" \
    -destination "platform=iOS Simulator,name=$SIMULATOR_NAME,OS=$IOS_VERSION" \
    -quiet \
    CODE_SIGNING_ALLOWED=NO \
    ONLY_ACTIVE_ARCH=YES

print_status $? "Project builds successfully"

# Test 7: Run unit tests
echo -e "\n${BLUE}7. Running Unit Tests${NC}"
echo "---------------------"

print_info "Running development environment tests..."
xcodebuild test \
    -scheme "$SCHEME_NAME" \
    -destination "platform=iOS Simulator,name=$SIMULATOR_NAME,OS=$IOS_VERSION" \
    -only-testing:SeminoteTests/DevelopmentEnvironmentTests \
    -quiet \
    CODE_SIGNING_ALLOWED=NO

print_status $? "Unit tests passed"

# Test 8: Performance validation
echo -e "\n${BLUE}8. Performance Validation${NC}"
echo "-------------------------"

print_info "Running performance tests..."
xcodebuild test \
    -scheme "$SCHEME_NAME" \
    -destination "platform=iOS Simulator,name=$SIMULATOR_NAME,OS=$IOS_VERSION" \
    -only-testing:SeminoteTests/DevelopmentEnvironmentTests/testAudioProcessingLatency \
    -only-testing:SeminoteTests/DevelopmentEnvironmentTests/testMLProcessingPerformance \
    -quiet \
    CODE_SIGNING_ALLOWED=NO

print_status $? "Performance tests passed"

# Test 9: Code quality check (if SwiftLint is available)
echo -e "\n${BLUE}9. Code Quality Check${NC}"
echo "---------------------"

if command -v swiftlint &> /dev/null; then
    print_info "Running SwiftLint..."
    swiftlint --quiet
    print_status $? "Code quality check passed"
else
    print_warning "SwiftLint not installed, skipping code quality check"
    print_info "Install with: brew install swiftlint"
fi

# Test 10: Memory and performance analysis
echo -e "\n${BLUE}10. Memory Analysis${NC}"
echo "-------------------"

print_info "Running memory usage tests..."
xcodebuild test \
    -scheme "$SCHEME_NAME" \
    -destination "platform=iOS Simulator,name=$SIMULATOR_NAME,OS=$IOS_VERSION" \
    -only-testing:SeminoteTests/DevelopmentEnvironmentTests/testMemoryUsage \
    -quiet \
    CODE_SIGNING_ALLOWED=NO

print_status $? "Memory analysis completed"

# Summary
echo -e "\n${GREEN}🎉 All Tests Completed Successfully!${NC}"
echo "====================================="
echo ""
echo "✅ Xcode and iOS SDK configured"
echo "✅ Swift Package Manager working"
echo "✅ Project structure validated"
echo "✅ Build system functional"
echo "✅ Unit tests passing"
echo "✅ Performance tests passing"
echo "✅ Memory usage within limits"
echo ""
echo -e "${BLUE}📱 iOS Development Environment is ready for SEM-36!${NC}"
echo ""
echo "Next steps:"
echo "1. Review and merge the pull request"
echo "2. Proceed with SEM-43 (Architecture Design)"
echo "3. Set up physical device testing"
echo ""
echo -e "${YELLOW}Note: For production deployment, configure:${NC}"
echo "- Apple Developer certificates"
echo "- Provisioning profiles"
echo "- App Store Connect integration"
