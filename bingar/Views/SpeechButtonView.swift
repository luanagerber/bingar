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

struct SpeechButtonView: View {

    @StateObject var speechProcessor = SpeechButtonViewModel()
    
    @StateObject var speechRecognizer = SpeechTranscriptor()
    
//    @EnvironmentObject var bingoModel: BingoViewModel
    
    var body: some View {
        Button(action: {
            speechProcessor.handleButtonTap()
        }) {
            Image(systemName: speechProcessor.isRecording ? "stop.circle" : "mic.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .fontWeight(.light)
                .foregroundColor(speechProcessor.isRecording ? .pink : .black.opacity(0.7))
        }
    }
    
}
