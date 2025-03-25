//
//  SpeechManager.swift
//  bingar
//
//  Created by Luana Gerber on 25/03/25.
//

import SwiftUI
import AVFAudio
import AVFoundation
import Foundation
import Speech

struct SpeechManager: View {
    
    @StateObject var speechRecognizer = SpeechRecognizer()
    
    @State private var isRecording = false
    @State var transcrip: String = ""
    
    var bingoModel: BingoModel
    
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
    
    func handleButtonTap() {
        if isRecording {
            speechRecognizer.stopTranscribing()
            isRecording = false
            transcrip = speechRecognizer.transcript
            print(transcrip)
        } else {
            speechRecognizer.resetTranscript()
            speechRecognizer.startTranscribing()
            isRecording = true
        }
    }
    
}
