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
    
    @ObservedObject var speechTranscriptor = SpeechTranscriptor()
    
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
            speechTranscriptor.stopTranscribing()
            isRecording = false
            
            let extractedNumber = processText(text: speechTranscriptor.transcript)  // Now uses the real transcript
            bingoViewModel.addSortedNumber(number: extractedNumber)
            
            print("sortedNumbers: \(bingoViewModel.sortedNumbers)")
            
        } else {
            isRecording = true
            speechTranscriptor.startTranscribing()  // No need to reset transcript manually
        }
    }
    
    func processText(text: String) -> Int {
        let optimizedText = optimizeText(text: text)
        print("optimizedText: \(optimizedText)")
        
        let transcriptedNumber = extractNumber(optimizedText: optimizedText)
        print("transcriptedNumber: \(transcriptedNumber)")

        return transcriptedNumber
    }
    
    func optimizeText(text: String) -> String {
        let text = text
            .replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) // Keep only numbers
        
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
