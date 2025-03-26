//
//  SpeechProcessor.swift
//  bingar
//
//  Created by Luana Gerber on 25/03/25.
//

import Foundation
import Speech

class SpeechViewModel: ObservableObject {
    
    @Published var isRecording: Bool = false
    @Published var extractedNumber: Int = 00
    @Published var transcript: String = ""
    
    private var speechTranscriptor = SpeechTranscriptor()
    
    @MainActor func handleButtonTap(bingoViewModel: BingoViewModel) {
        if isRecording {
            speechTranscriptor.stopTranscribing()
            isRecording = false
            
            extractedNumber = processText(text: speechTranscriptor.transcript)
            bingoViewModel.addSortedNumber(number: extractedNumber)
            
            print("sortedNumbers: \(bingoViewModel.sortedNumbers)")
            
        } else {
            isRecording = true
            speechTranscriptor.startTranscribing()
        }
    }
    
    private func processText(text: String) -> Int {
            let optimizedText = optimizeText(text: text)
            print("optimizedText: \(optimizedText)")
            
            let transcriptedNumber = extractNumber(optimizedText: optimizedText)
            print("transcriptedNumber: \(transcriptedNumber)")

            return transcriptedNumber
        }
    
    private func optimizeText(text: String) -> String {
            let text = text
                .replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) // Keep only numbers
            
            return text
            
        }
    
    private func extractNumber(optimizedText: String) -> Int {
            let transcriptedNumber = Int(optimizedText) ?? 0
            
            if 0 < transcriptedNumber && transcriptedNumber < 76 {
                return transcriptedNumber
            } else {
                return 0
            }
            
        }
}
