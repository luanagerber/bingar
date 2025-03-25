//
//  SpeechProcessor.swift
//  bingar
//
//  Created by Luana Gerber on 25/03/25.
//

struct SpeechProcessor {
    var transcriptedText: String
    var optimizedText: String
    var transcriptedNumber: Int
    
    mutating func processText(text: String) {
        let text = text
        optimizedText = text.replacingOccurrences(of: " ", with: "")
    }
    
    mutating func extractNumber(optimizedText: String) -> Int {
        transcriptedNumber = Int(optimizedText) ?? 0
        
        if transcriptedNumber != 0 && transcriptedNumber < 76 {
            return transcriptedNumber
        } else {
            print("No valid number found")
            return 0
        }
    }
    
}
