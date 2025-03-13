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
            Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(isRecording ? .red : .blue)
                .padding()
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
