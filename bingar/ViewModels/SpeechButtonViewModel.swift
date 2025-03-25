//
//  SpeechProcessor.swift
//  bingar
//
//  Created by Luana Gerber on 25/03/25.
//

import SwiftUI

class SpeechButtonViewModel: ObservableObject {
//    var transcriptedText: String
    
    @StateObject var speechRecognizer = SpeechTranscriptor()
    
    @State var isRecording = false
    @State var transcript: String = ""
    @State var extractedNumber: Int?
    
    @EnvironmentObject var bingoModel: BingoGridViewModel
    
    func handleButtonTap() {
        if isRecording {
            speechRecognizer.stopTranscribing()
            isRecording = false
            transcript = speechRecognizer.transcript
            extractedNumber = processText(text: transcript)
            bingoModel.extractedNumber = extractedNumber
            
            print("bingoModel.extractedNumber: ", bingoModel.extractedNumber!)
            
        } else {
            speechRecognizer.resetTranscript()
            speechRecognizer.startTranscribing()
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
