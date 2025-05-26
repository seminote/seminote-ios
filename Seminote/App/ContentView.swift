import SwiftUI
import SeminoteCore
import SeminoteAudio
import SeminoteML

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var audioEngine: AudioEngine
    @EnvironmentObject var mlProcessor: MLProcessor
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Practice Tab
            PracticeView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Practice")
                }
                .tag(0)
            
            // Learning Tab
            LearningView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Learn")
                }
                .tag(1)
            
            // Progress Tab
            ProgressView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Progress")
                }
                .tag(2)
            
            // Settings Tab
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(.blue)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Practice View

struct PracticeView: View {
    @EnvironmentObject var audioEngine: AudioEngine
    @EnvironmentObject var mlProcessor: MLProcessor
    @State private var isRecording = false
    @State private var currentNote: DetectedNote?
    @State private var processingMode: ProcessingMode = .local
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack {
                    Text("Practice Session")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Processing Mode: \(processingMode.displayName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Audio Visualization
                AudioVisualizationView(audioEngine: audioEngine)
                    .frame(height: 200)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                
                // Current Note Display
                if let note = currentNote {
                    NoteDisplayView(note: note)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }
                
                // Controls
                VStack(spacing: 16) {
                    Button(action: toggleRecording) {
                        HStack {
                            Image(systemName: isRecording ? "stop.circle.fill" : "play.circle.fill")
                            Text(isRecording ? "Stop Practice" : "Start Practice")
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(isRecording ? Color.red : Color.blue)
                        .cornerRadius(12)
                    }
                    
                    HStack {
                        Button("Slow Practice") {
                            processingMode = .edge
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Normal Practice") {
                            processingMode = .hybrid
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Fast Practice") {
                            processingMode = .local
                        }
                        .buttonStyle(.bordered)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .onReceive(mlProcessor.noteDetectedPublisher) { note in
            currentNote = note
        }
    }
    
    private func toggleRecording() {
        if isRecording {
            audioEngine.stopRecording()
            mlProcessor.stopProcessing()
        } else {
            audioEngine.startRecording()
            mlProcessor.startProcessing(mode: processingMode)
        }
        isRecording.toggle()
    }
}

// MARK: - Learning View

struct LearningView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Learning Center")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Coming Soon")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Progress View

struct ProgressView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Your Progress")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Coming Soon")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            List {
                Section("Audio Settings") {
                    HStack {
                        Text("Buffer Size")
                        Spacer()
                        Text("\(appState.deviceCapabilities?.recommendedBufferSize ?? 256) samples")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Sample Rate")
                        Spacer()
                        Text("44.1 kHz")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Device Info") {
                    if let capabilities = appState.deviceCapabilities {
                        HStack {
                            Text("Local ML Support")
                            Spacer()
                            Text(capabilities.supportsLocalML ? "Yes" : "No")
                                .foregroundColor(capabilities.supportsLocalML ? .green : .red)
                        }
                        
                        HStack {
                            Text("Ultra Low Latency")
                            Spacer()
                            Text(capabilities.supportsUltraLowLatency ? "Yes" : "No")
                                .foregroundColor(capabilities.supportsUltraLowLatency ? .green : .red)
                        }
                        
                        HStack {
                            Text("Processor Cores")
                            Spacer()
                            Text("\(capabilities.processorCount)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
        .environmentObject(AudioEngine())
        .environmentObject(MLProcessor())
}
