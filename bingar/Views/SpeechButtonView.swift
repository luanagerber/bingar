//
//  SpeechButtonView.swift
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
    
    @State var isRecording: Bool = false
    @State var transcript: String = ""
    
    var speechTranscriptor = SpeechTranscriptor()
    
    @EnvironmentObject var bingoViewModel: BingoGridViewModel
    
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
            speechTranscriptor.transcript = transcript
            speechTranscriptor.stopTranscribing()
            isRecording = false
            
            let extractedNumber = processText(text: transcript)
            bingoViewModel.addSortedNumber(number: extractedNumber)
            print(bingoViewModel.sortedNumbers)
        } else {
            speechTranscriptor.resetTranscript()
            speechTranscriptor.startTranscribing()
            isRecording = true
        }
    }
    
    func processText(text: String) -> Int {
        let optimizedText = optimizeText(text: text)
        print("optimizedText: \(text)")

        let transcriptedNumber = extractNumber(optimizedText: optimizedText)
        print("transcriptedNumber: \(transcriptedNumber)")

        return transcriptedNumber
    }
    
    func optimizeText(text: String) -> String {
        let text = text
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "[BINGO]", with: "", options: .regularExpression)
        
        return text
            
    }
    
    func extractNumber(optimizedText: String) -> Int {
        let transcriptedNumber = Int(optimizedText) ?? 0
        
        if 0 < transcriptedNumber && transcriptedNumber < 76 {
            return transcriptedNumber
        } else {
            return 0
        }
        
    }
}
