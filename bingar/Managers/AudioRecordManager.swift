import SwiftUI
import AVFAudio

struct AudioRecordManager: View {
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder?
    
    @State private var recordingURL: URL?
    
    @State private var showPermissionAlert = false
    
    var body: some View {
        Button(action: {
            handleButtonTap()
        }) {
            Image(systemName: isRecording ? "stop.circle" : "mic.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .fontWeight(.light)
                .foregroundColor(isRecording ? .pink : .black.opacity(0.7))
        }
    }
    
    private func handleButtonTap() {
            if isRecording {
                stopRecording()
                isRecording = false
            } else {
                startRecording()
                isRecording = true
            }
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)
            
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentPath.appendingPathComponent("temp_recording.wav")
            recordingURL = audioFilename
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM), // Use Linear PCM for WAV
                AVSampleRateKey: 44100, // Standard CD-quality sample rate
                AVNumberOfChannelsKey: 2, // Stereo recording
                AVLinearPCMBitDepthKey: 16, // 16-bit depth for standard quality
                AVLinearPCMIsBigEndianKey: false, // Little-endian format (default)
                AVLinearPCMIsFloatKey: false // Standard integer samples
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            
            print("Started recording.")
            print("Document path: \(documentPath)")
            
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
        
        if let fileURL = recordingURL {
                    do {
                        if FileManager.default.fileExists(atPath: fileURL.path) {
                            print("File exists, deleting...")
                            try FileManager.default.removeItem(at: fileURL)
                            print("Recording file deleted successfully")
                        }
                    } catch {
                        print("Error deleting recording file: \(error.localizedDescription)")
                    }
                }
        
        recordingURL = nil
    }
}
