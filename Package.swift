// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Seminote",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Seminote",
            targets: ["Seminote"]
        ),
        .library(
            name: "SeminoteCore",
            targets: ["SeminoteCore"]
        ),
        .library(
            name: "SeminoteAudio",
            targets: ["SeminoteAudio"]
        ),
        .library(
            name: "SeminoteML",
            targets: ["SeminoteML"]
        )
    ],
    dependencies: [
        // Audio Processing
        .package(url: "https://github.com/AudioKit/AudioKit.git", from: "5.6.0"),
        .package(url: "https://github.com/AudioKit/SoundpipeAudioKit.git", from: "5.6.0"),

        // Networking & WebRTC
        .package(url: "https://github.com/stasel/WebRTC.git", from: "120.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),

        // UI & Animations
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "1.1.0"),
        .package(url: "https://github.com/exyte/PopupView.git", from: "2.8.0"),

        // Utilities
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.5.0"),

        // Testing
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.15.0")
    ],
    targets: [
        // Main App Target
        .target(
            name: "Seminote",
            dependencies: [
                "SeminoteCore",
                "SeminoteAudio",
                "SeminoteML",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SwiftUIIntrospect", package: "SwiftUI-Introspect"),
                .product(name: "PopupView", package: "PopupView")
            ],
            path: "Seminote/App"
        ),

        // Core Framework
        .target(
            name: "SeminoteCore",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Alamofire", package: "Alamofire")
            ],
            path: "Seminote/Core",
            exclude: ["Audio", "ML"]
        ),

        // Audio Processing Framework
        .target(
            name: "SeminoteAudio",
            dependencies: [
                "SeminoteCore",
                .product(name: "AudioKit", package: "AudioKit"),
                .product(name: "SoundpipeAudioKit", package: "SoundpipeAudioKit"),
                .product(name: "WebRTC", package: "WebRTC")
            ],
            path: "Seminote/Core/Audio"
        ),

        // Machine Learning Framework
        .target(
            name: "SeminoteML",
            dependencies: [
                "SeminoteCore",
                "SeminoteAudio"
            ],
            path: "Seminote/Core/ML"
        ),

        // Test Targets
        .testTarget(
            name: "SeminoteTests",
            dependencies: [
                "Seminote",
                "SeminoteCore",
                "SeminoteAudio",
                "SeminoteML",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "SeminoteTests"
        ),

        .testTarget(
            name: "SeminoteUITests",
            dependencies: ["Seminote"],
            path: "SeminoteUITests"
        )
    ],
    swiftLanguageModes: [.v5]
)
