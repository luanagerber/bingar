//
//  SpeechProcessor.swift
//  bingar
//
//  Created by Luana Gerber on 25/03/25.
//

import SwiftUI

class SpeechButtonViewModel: ObservableObject {
    
    @StateObject var speechTranscriptor = SpeechTranscriptor()
    
    @State var isRecording = false
    @State var transcript: String = ""
    
    @EnvironmentObject var bingoViewModel: BingoGridViewModel
    
    func handleButtonTap() {
        if isRecording {
            speechTranscriptor.stopTranscribing()
            isRecording = false
            transcript = speechTranscriptor.transcript
            
            let extractedNumber = processText(text: transcript)
            bingoViewModel.addSortedNumber(number: extractedNumber)
        } else {
            speechTranscriptor.resetTranscript()
            speechTranscriptor.startTranscribing()
            isRecording = true
        }
    }
    
    func processText(text: String) -> Int {
        let optimizedText = optimizeText(text: text)
        let transcriptedNumber = extractNumber(optimizedText: optimizedText)
        
        print(transcriptedNumber)
        return transcriptedNumber
    }
    
    func optimizeText(text: String) -> String {
        return text
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "[BINGO]", with: "", options: .regularExpression)
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
