import SwiftUI
import SeminoteCore
import SeminoteAudio
import SeminoteML
import ComposableArchitecture
import AVFoundation
import os.log

#if canImport(UIKit)
import UIKit
#endif

@main
struct SeminoteApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var audioEngine = AudioEngine()
    @StateObject private var mlProcessor = MLProcessor()

    private let logger = Logger(subsystem: "com.seminote.ios", category: "App")

    init() {
        setupAudioSession()
        setupLogging()
        setupAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(audioEngine)
                .environmentObject(mlProcessor)
                .onAppear {
                    initializeApp()
                }
                #if canImport(UIKit)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    handleAppDidEnterBackground()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    handleAppWillEnterForeground()
                }
                #endif
        }
    }

    // MARK: - Setup Methods

    private func setupAudioSession() {
        #if os(iOS)
        do {
            let audioSession = AVAudioSession.sharedInstance()

            // Configure audio session for low-latency audio processing
            try audioSession.setCategory(
                .playAndRecord,
                mode: .measurement,
                options: [
                    .defaultToSpeaker,
                    .allowBluetooth,
                    .allowBluetoothA2DP,
                    .mixWithOthers
                ]
            )

            // Set preferred buffer size for minimal latency
            try audioSession.setPreferredIOBufferDuration(0.005) // 5ms buffer
            try audioSession.setPreferredSampleRate(44100.0)

            try audioSession.setActive(true)

            logger.info("Audio session configured successfully")

        } catch {
            logger.error("Failed to configure audio session: \(error.localizedDescription)")
        }
        #else
        logger.info("Audio session setup skipped on non-iOS platform")
        #endif
    }

    private func setupLogging() {
        // Configure logging levels based on build configuration
        #if DEBUG
        logger.info("Debug logging enabled")
        #else
        logger.info("Release logging enabled")
        #endif
    }

    private func setupAppearance() {
        #if canImport(UIKit)
        // Configure global app appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        #endif
    }

    // MARK: - App Lifecycle

    private func initializeApp() {
        logger.info("Initializing Seminote app")

        Task {
            await initializeServices()
        }
    }

    private func initializeServices() async {
        // Initialize Core ML models
        await mlProcessor.loadModels()

        // Initialize audio engine
        await audioEngine.initialize()

        // Check device capabilities
        await appState.checkDeviceCapabilities()

        logger.info("App services initialized successfully")
    }

    private func handleAppDidEnterBackground() {
        logger.info("App entering background")

        // Pause audio processing if not in practice session
        if !appState.isInPracticeSession {
            audioEngine.pause()
        }

        // Save app state
        appState.saveState()
    }

    private func handleAppWillEnterForeground() {
        logger.info("App entering foreground")

        // Resume audio processing
        audioEngine.resume()

        // Restore app state
        appState.restoreState()
    }
}

// MARK: - App State

@MainActor
class AppState: ObservableObject {
    @Published var isInPracticeSession = false
    @Published var deviceCapabilities: DeviceCapabilities?
    @Published var networkStatus: NetworkStatus = .unknown

    private let logger = Logger(subsystem: "com.seminote.ios", category: "AppState")

    func checkDeviceCapabilities() async {
        let capabilities = DeviceCapabilities.current
        self.deviceCapabilities = capabilities

        logger.info("Device capabilities: \(capabilities.description)")
    }

    func saveState() {
        // Implement state persistence
        logger.debug("Saving app state")
    }

    func restoreState() {
        // Implement state restoration
        logger.debug("Restoring app state")
    }
}

// MARK: - Device Capabilities

struct DeviceCapabilities {
    let supportsLocalML: Bool
    let supportsUltraLowLatency: Bool
    let recommendedBufferSize: UInt32
    let processorCount: Int
    let memorySize: UInt64

    static var current: DeviceCapabilities {
        let processInfo = ProcessInfo.processInfo

        #if os(iOS)
        let isInputAvailable = AVAudioSession.sharedInstance().isInputAvailable
        let bufferSize: UInt32 = UIDevice.current.userInterfaceIdiom == .pad ? 128 : 256
        #else
        let isInputAvailable = true // Assume input is available on other platforms
        let bufferSize: UInt32 = 256 // Default buffer size for non-iOS platforms
        #endif

        return DeviceCapabilities(
            supportsLocalML: processInfo.processorCount >= 6,
            supportsUltraLowLatency: isInputAvailable,
            recommendedBufferSize: bufferSize,
            processorCount: processInfo.processorCount,
            memorySize: processInfo.physicalMemory
        )
    }

    var description: String {
        return """
        Local ML: \(supportsLocalML)
        Ultra Low Latency: \(supportsUltraLowLatency)
        Buffer Size: \(recommendedBufferSize)
        Processors: \(processorCount)
        Memory: \(memorySize / 1024 / 1024)MB
        """
    }
}

// MARK: - Network Status

enum NetworkStatus {
    case unknown
    case offline
    case online
    case edge
}
