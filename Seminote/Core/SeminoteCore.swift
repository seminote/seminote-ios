import Foundation
import Logging
import Collections
import Alamofire

/// Core framework for Seminote iOS application
/// Provides shared utilities, networking, and base functionality
public struct SeminoteCore {
    
    /// Shared logger instance
    public static let logger = Logger(label: "com.seminote.core")
    
    /// App version information
    public struct Version {
        public static let current = "1.0.0"
        public static let build = "1"
    }
    
    /// Network configuration
    public struct NetworkConfig {
        public static let baseURL = "https://api.seminote.com"
        public static let timeout: TimeInterval = 30.0
    }
    
    /// Initialize the core framework
    public static func initialize() {
        logger.info("SeminoteCore initialized - version \(Version.current)")
    }
}

/// Base error types for Seminote
public enum SeminoteError: Error, LocalizedError {
    case networkError(String)
    case audioError(String)
    case mlError(String)
    case configurationError(String)
    
    public var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network Error: \(message)"
        case .audioError(let message):
            return "Audio Error: \(message)"
        case .mlError(let message):
            return "ML Error: \(message)"
        case .configurationError(let message):
            return "Configuration Error: \(message)"
        }
    }
}

/// Device capabilities detection
public struct DeviceCapabilities {
    public let supportsLocalML: Bool
    public let supportsUltraLowLatency: Bool
    public let recommendedBufferSize: UInt32
    public let processorCount: Int
    public let memorySize: UInt64
    
    public init() {
        let processInfo = ProcessInfo.processInfo
        
        self.supportsLocalML = processInfo.processorCount >= 6
        self.supportsUltraLowLatency = true // Will be determined by audio session
        self.recommendedBufferSize = 256
        self.processorCount = processInfo.processorCount
        self.memorySize = processInfo.physicalMemory
    }
}
