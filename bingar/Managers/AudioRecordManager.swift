import SwiftUI
import AVFAudio

struct AudioRecordButton: View {
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
            let audioFilename = documentPath.appendingPathComponent("recording.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        let audioSession = AVAudioApplication.sharedInstance()
        try? audioSession.setActive(false)
    }
}
