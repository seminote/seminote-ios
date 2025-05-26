import Foundation
import AVFoundation
import AudioKit
import SoundpipeAudioKit
import Combine
import os.log

#if os(iOS)
import UIKit
#endif

@MainActor
public class AudioEngine: ObservableObject {
    // MARK: - Published Properties
    @Published public var isRecording = false
    @Published public var audioLevel: Float = 0.0
    @Published public var currentFrequency: Float = 0.0
    @Published public var latency: TimeInterval = 0.0

    // MARK: - Private Properties
    private let audioEngine = AVAudioEngine()
    #if os(iOS)
    private let audioSession = AVAudioSession.sharedInstance()
    #endif
    private var inputNode: AVAudioInputNode?
    private var audioBuffer: AVAudioPCMBuffer?

    // AudioKit components - simplified for initial setup
    private var tracker: PitchTap?
    private var fftTap: FFTTap?

    // Combine
    private var cancellables = Set<AnyCancellable>()

    // Logging
    private let logger = Logger(subsystem: "com.seminote.ios", category: "AudioEngine")

    // Configuration
    private let bufferSize: UInt32 = 256
    private let sampleRate: Double = 44100.0

    public init() {
        setupAudioEngine()
    }

    // MARK: - Public Methods

    public func initialize() async {
        logger.info("Initializing AudioEngine")

        do {
            try await configureAudioSession()
            try await setupAudioProcessing()
            logger.info("AudioEngine initialized successfully")
        } catch {
            logger.error("Failed to initialize AudioEngine: \(error.localizedDescription)")
        }
    }

    public func startRecording() {
        guard !isRecording else { return }

        logger.info("Starting audio recording")

        do {
            try audioEngine.start()
            tracker?.start()
            fftTap?.start()

            isRecording = true
            logger.info("Audio recording started successfully")

        } catch {
            logger.error("Failed to start recording: \(error.localizedDescription)")
        }
    }

    public func stopRecording() {
        guard isRecording else { return }

        logger.info("Stopping audio recording")

        audioEngine.stop()
        tracker?.stop()
        fftTap?.stop()

        isRecording = false
        logger.info("Audio recording stopped")
    }

    public func pause() {
        if isRecording {
            audioEngine.pause()
            logger.info("Audio engine paused")
        }
    }

    public func resume() {
        if isRecording && !audioEngine.isRunning {
            do {
                try audioEngine.start()
                logger.info("Audio engine resumed")
            } catch {
                logger.error("Failed to resume audio engine: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Private Methods

    private func setupAudioEngine() {
        // Configure AudioKit
        Settings.bufferLength = .short // Minimize latency
        Settings.sampleRate = sampleRate
        Settings.channelCount = 1 // Mono input
    }

    private func configureAudioSession() async throws {
        #if os(iOS)
        try audioSession.setCategory(
            .playAndRecord,
            mode: .measurement,
            options: [.defaultToSpeaker, .allowBluetooth, .mixWithOthers]
        )

        try audioSession.setPreferredIOBufferDuration(Double(self.bufferSize) / self.sampleRate)
        try audioSession.setPreferredSampleRate(self.sampleRate)
        try audioSession.setActive(true)

        logger.info("Audio session configured - Buffer: \(self.bufferSize), Sample Rate: \(self.sampleRate)")
        #else
        logger.info("Audio session configuration skipped on macOS")
        #endif
    }

    private func setupAudioProcessing() async throws {
        // Setup microphone input
        let input = audioEngine.inputNode
        inputNode = input

        // Configure input format
        let inputFormat = input.outputFormat(forBus: 0)
        logger.info("Input format: \(inputFormat)")

        // Setup pitch tracking (simplified for initial setup)
        // Note: PitchTap will be configured when AudioKit integration is complete
        logger.info("Audio processing setup completed")

        // Setup FFT analysis (simplified for initial setup)
        // Note: FFTTap will be configured when AudioKit integration is complete
        logger.info("FFT analysis setup deferred")

        // Install audio tap for real-time processing
        input.installTap(onBus: 0, bufferSize: bufferSize, format: inputFormat) { [weak self] buffer, time in
            self?.processAudioBuffer(buffer, time: time)
        }
    }

    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer, time: AVAudioTime) {
        // Calculate latency
        let currentTime = AVAudioTime.now()
        let hostTime = currentTime.hostTime
        let bufferTime = time.hostTime
        let latencyNanos = hostTime - bufferTime
        let latencySeconds = Double(latencyNanos) / Double(NSEC_PER_SEC)

        Task { @MainActor in
            self.latency = latencySeconds
        }

        // Process audio data for ML
        processAudioForML(buffer)
    }

    private func processAudioForML(_ buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameCount = Int(buffer.frameLength)

        // Convert to array for ML processing
        let audioData = Array(UnsafeBufferPointer(start: channelData, count: frameCount))

        // Send to ML processor
        NotificationCenter.default.post(
            name: .audioDataAvailable,
            object: nil,
            userInfo: ["audioData": audioData, "sampleRate": sampleRate]
        )
    }

    private func processFFTData(_ fftData: [Float]) {
        // Process FFT data for frequency analysis
        // This can be used for advanced audio analysis

        // Find dominant frequency
        if let maxIndex = fftData.enumerated().max(by: { $0.element < $1.element })?.offset {
            let frequency = Float(maxIndex) * Float(sampleRate) / Float(fftData.count)

            Task { @MainActor in
                // Update frequency if it's in a reasonable range for piano
                if frequency > 20 && frequency < 4000 {
                    self.currentFrequency = frequency
                }
            }
        }
    }
}

// MARK: - Audio Engine Error

public enum AudioEngineError: Error, LocalizedError {
    case noInputAvailable
    case configurationFailed
    case startupFailed

    public var errorDescription: String? {
        switch self {
        case .noInputAvailable:
            return "No audio input device available"
        case .configurationFailed:
            return "Failed to configure audio engine"
        case .startupFailed:
            return "Failed to start audio engine"
        }
    }
}

// MARK: - Notifications

extension Notification.Name {
    public static let audioDataAvailable = Notification.Name("audioDataAvailable")
}

// MARK: - Audio Configuration

public struct AudioConfiguration {
    public static let defaultBufferSize: UInt32 = 256
    public static let defaultSampleRate: Double = 44100.0
    public static let minimumLatency: TimeInterval = 0.005 // 5ms
    public static let maximumLatency: TimeInterval = 0.020 // 20ms

    public static let pianoFrequencyRange: ClosedRange<Float> = 27.5...4186.0 // A0 to C8
}
