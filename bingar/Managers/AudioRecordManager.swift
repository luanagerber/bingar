//
//  AudioRecordManager.swift
//  bingar
//
//  Created by Luana Gerber on 13/03/25.
//

import SwiftUI
import AVFoundation

struct AudioRecordButton: View {
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder?
    
    var body: some View {
        Button(action: {
            if isRecording {
                stopRecording()
            } else {
                startRecording()
            }
            isRecording.toggle()
        }) {
            Image(systemName: isRecording ? "stop.circle" : "mic.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .fontWeight(.light)
                .foregroundColor(isRecording ? .pink : .black.opacity(0.7))
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
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }
}
