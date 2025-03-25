//
//  BingoToNumbersManager.swift
//  bingar
//
//  Created by Luana Gerber on 24/03/25.
//

import SwiftUI
import Vision
import UIKit

func processImageToNumbers(in image: UIImage, bingoModel: BingoModel) {
    guard let cgImage = image.cgImage else { return }
    
    let textRequest = VNRecognizeTextRequest { request, error in
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        
        var detectedNumbers: [(number: String, rect: CGRect)] = []
        
        for observation in observations {
            if let topCandidate = observation.topCandidates(1).first {
                let rect = VNImageRectForNormalizedRect(
                    observation.boundingBox,
                    cgImage.width,
                    cgImage.height
                )
                
                if let number = Int(topCandidate.string) {
                    detectedNumbers.append((String(number), rect))
                }
            }
        }
        
        // Atualizar o modelo com os números detectados
        processDetectedNumbers(detectedNumbers, bingoModel: bingoModel)
    }
    
    textRequest.usesLanguageCorrection = false
    textRequest.recognitionLevel = .accurate
    textRequest.automaticallyDetectsLanguage = false
    textRequest.recognitionLanguages = ["pt-BR"]
    
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    try? handler.perform([textRequest])
}


// MARK: - Processamento dos Números Detectados
func processDetectedNumbers(_ numbers: [(number: String, rect: CGRect)], bingoModel: BingoModel) {
    guard !numbers.isEmpty else { return }

    // 1. First, sort by Y position (top to bottom)
    let sortedByRow = numbers.sorted { $0.rect.minY < $1.rect.minY }
    
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
    
    DispatchQueue.main.async {
        print(bingoGrid)
        bingoModel.updateNumbers(newNumbers: bingoGrid)
    }
}
