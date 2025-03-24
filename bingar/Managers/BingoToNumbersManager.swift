//
//  BingoToNumbersManager.swift
//  bingar
//
//  Created by Luana Gerber on 24/03/25.
//

import SwiftUI
import Vision
import UIKit

func detectBingoNumbers(in image: UIImage) {
    guard let cgImage = image.cgImage else { return }
    
    // Create a text recognition request
    let textRequest = VNRecognizeTextRequest { request, error in
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        
        var bingoNumbers: [(number: String, rect: CGRect)] = []
        
        for observation in observations {
            // Get the top candidate text
            if let topCandidate = observation.topCandidates(1).first {
                // Convert normalized coordinates to image coordinates
                let rect = VNImageRectForNormalizedRect(
                    observation.boundingBox,
                    cgImage.width,
                    cgImage.height
                )

                // Only include text that looks like numbers
                if let number = Int(topCandidate.string) {
                    bingoNumbers.append((String(number), rect))
                }
            }
        }
        
        // Process the detected numbers with their positions
        processDetectedNumbers(bingoNumbers)
    }
    
    // Configure the text recognition request
    textRequest.usesLanguageCorrection = false
    textRequest.recognitionLevel = .accurate
    textRequest.automaticallyDetectsLanguage = false
    textRequest.recognitionLanguages = ["pt-BR"]
    
    // Create and perform the request
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    try? handler.perform([textRequest])
}

func processDetectedNumbers(_ numbers: [(number: String, rect: CGRect)]) {
    // 1. First, sort by Y position (top to bottom)
    let sortedByRow = numbers.sorted { $0.rect.minY > $1.rect.minY }
    
    // 2. Group into 5 rows based on Y position clusters
    var rows: [[(number: String, rect: CGRect)]] = []
    var currentRow: [(number: String, rect: CGRect)] = []
    var lastY: CGFloat = -1
    let yThreshold: CGFloat = 50 // Adjust based on your card's spacing
    
    for item in sortedByRow {
        if lastY == -1 || abs(item.rect.minY - lastY) < yThreshold {
            // Same row
            currentRow.append(item)
        } else {
            // New row
            if !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow = []
            }
            currentRow.append(item)
        }
        lastY = item.rect.minY
    }
    if !currentRow.isEmpty {
        rows.append(currentRow)
    }
    
    // 3. Within each row, sort by X position (left to right)
    //        var bingoGrid: [[Int?]] = []
    var bingoGrid: [[Int?]] = []
    
    for row in rows {
        let sortedRow = row.sorted { $0.rect.minX < $1.rect.minX }
        let rowNumbers: [Int?] = sortedRow.map { Int($0.number) }
        bingoGrid.append(rowNumbers)
    }
    
    // 4. Ensure we have a 5x5 grid with nil for the free space
    while bingoGrid.count < 5 {
        bingoGrid.append([nil, nil, nil, nil, nil])
    }
    
    // Make sure each row has 5 elements
    for i in 0..<bingoGrid.count {
        while bingoGrid[i].count < 5 {
            bingoGrid[i].append(nil)
        }
    }
    
    // 5. Handle the center free space (if needed)
    if bingoGrid.count >= 3 && bingoGrid[2].count >= 3 {
        bingoGrid[2][2] = nil
    }
    
//        print(bingoGrid)
    
    // Print grid without Optional wrappers
    for row in bingoGrid {
        print("[", terminator: "")
        for (index, num) in row.enumerated() {
            if let number = num {
                print("\(number)", terminator: "")
            } else {
                print("nil", terminator: "")
            }
            
            if index < row.count - 1 {
                print(", ", terminator: "")
            }
        }
        print("]")
    }
}
