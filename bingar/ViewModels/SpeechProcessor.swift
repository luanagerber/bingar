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
    
    mutating func processText(text: String) -> Int {
        optimizedText = optimizeText(text: text)
        transcriptedNumber = extractNumber(optimizedText: optimizedText)
        return transcriptedNumber
    }
    
    mutating func optimizeText(text: String) -> String {
        return text
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "[BINGO]", with: "", options: .regularExpression)
    }
    
    mutating func extractNumber(optimizedText: String) -> Int {
        transcriptedNumber = Int(optimizedText) ?? 0
        
        if 0 < transcriptedNumber && transcriptedNumber < 76 {
            return transcriptedNumber
        } else {
            return 0
        }
        
    }
    
}
