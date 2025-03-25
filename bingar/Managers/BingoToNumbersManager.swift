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
    
    let sortedByRow = numbers.sorted { $0.rect.minY > $1.rect.minY }
    
    var rows: [[(number: String, rect: CGRect)]] = []
    var currentRow: [(number: String, rect: CGRect)] = []
    var lastY: CGFloat = -1
    
    let averageHeight = sortedByRow.map { $0.rect.height }.reduce(0, +) / CGFloat(sortedByRow.count)
    let yThreshold = averageHeight * 0.6
    
    for item in sortedByRow {
        if lastY == -1 || abs(item.rect.minY - lastY) < yThreshold {
            currentRow.append(item)
        } else {
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
    
    var bingoGrid: [[Int?]] = Array(repeating: Array(repeating: nil, count: 5), count: 5)
    
    for (rowIndex, row) in rows.enumerated() {
        let sortedRow = row.sorted { $0.rect.minX < $1.rect.minX }
        for (colIndex, item) in sortedRow.enumerated() {
            bingoGrid[colIndex][rowIndex] = Int(item.number) // Store in column-major order
        }
    }
    
    if bingoGrid.count >= 3 && bingoGrid[2].count >= 3 {
        bingoGrid[2][2] = nil
    }
    
    DispatchQueue.main.async {
        bingoModel.updateNumbers(newNumbers: bingoGrid)
    }
}


