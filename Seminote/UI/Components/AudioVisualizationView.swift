import SwiftUI
import SeminoteAudio

struct AudioVisualizationView: View {
    @ObservedObject var audioEngine: AudioEngine
    @State private var waveformData: [Float] = Array(repeating: 0.0, count: 100)
    @State private var animationTimer: Timer?
    
    var body: some View {
        VStack(spacing: 16) {
            // Waveform Visualization
            WaveformView(data: waveformData)
                .frame(height: 80)
            
            // Audio Metrics
            HStack(spacing: 20) {
                MetricView(
                    title: "Level",
                    value: String(format: "%.1f dB", audioEngine.audioLevel),
                    color: audioLevelColor
                )
                
                MetricView(
                    title: "Frequency",
                    value: String(format: "%.1f Hz", audioEngine.currentFrequency),
                    color: .blue
                )
                
                MetricView(
                    title: "Latency",
                    value: String(format: "%.1f ms", audioEngine.latency * 1000),
                    color: latencyColor
                )
            }
        }
        .padding()
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            stopAnimation()
        }
    }
    
    private var audioLevelColor: Color {
        let level = audioEngine.audioLevel
        if level > 0.8 {
            return .red
        } else if level > 0.5 {
            return .orange
        } else {
            return .green
        }
    }
    
    private var latencyColor: Color {
        let latency = audioEngine.latency * 1000 // Convert to ms
        if latency > 20 {
            return .red
        } else if latency > 10 {
            return .orange
        } else {
            return .green
        }
    }
    
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            updateWaveform()
        }
    }
    
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func updateWaveform() {
        // Simulate waveform data based on audio level
        let level = audioEngine.audioLevel
        let frequency = audioEngine.currentFrequency
        
        // Generate synthetic waveform for visualization
        for i in 0..<waveformData.count {
            let phase = Float(i) * 0.1 + Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 2 * .pi)
            waveformData[i] = level * sin(phase * frequency / 100.0)
        }
    }
}

struct WaveformView: View {
    let data: [Float]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let stepWidth = width / CGFloat(data.count - 1)
                
                for (index, value) in data.enumerated() {
                    let x = CGFloat(index) * stepWidth
                    let y = height / 2 + CGFloat(value) * height / 4
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}

struct MetricView: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.medium)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct NoteDisplayView: View {
    let note: DetectedNote
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Detected Note")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("Confidence: \(Int(note.confidence * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 16) {
                // Note Display
                VStack {
                    Text(note.pitch.rawValue)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Octave \(note.octave)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Frequency Display
                VStack(alignment: .trailing) {
                    Text("\(String(format: "%.1f", note.frequency)) Hz")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("Velocity: \(note.velocity)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Confidence Bar
            ProgressView(value: note.confidence)
                .progressViewStyle(LinearProgressViewStyle(tint: confidenceColor))
                .scaleEffect(y: 2)
        }
    }
    
    private var confidenceColor: Color {
        if note.confidence > 0.8 {
            return .green
        } else if note.confidence > 0.6 {
            return .orange
        } else {
            return .red
        }
    }
}

#Preview {
    VStack {
        AudioVisualizationView(audioEngine: AudioEngine())
            .frame(height: 200)
        
        NoteDisplayView(note: DetectedNote(
            pitch: .A,
            octave: 4,
            frequency: 440.0,
            confidence: 0.85,
            timestamp: Date(),
            velocity: 64
        ))
        .padding()
    }
}
