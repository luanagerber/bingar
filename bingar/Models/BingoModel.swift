//
//  BingoModel.swift
//  bingar
//
//  Created by Luana Gerber on 13/03/25.
//

import Foundation
import UIKit

struct BingoModel {
    
    var matrix: [[Int?]] = [
        //B,  I,  N,  G,   O
        [8,  23,  36, 53, 66],
        [6, 16, 43, 51, 71],
        [15, 27, nil, 58, 65],
        [14, 26, 33, 57, 75],
        [13, 22, 41, 60, 64]
    ]
    
    var sortedNumbers: Set<Int> = []
    
    var victoryMessage: String = ""
    
    // Sort functions
    mutating func sortNumber() {
        var number = Int.random(in: 1...75)
        
        while sortedNumbers.contains(number) {
            number = Int.random(in: 1...75)  // Update number here
        }
        
        sortedNumbers.insert(number)
        print(number)
    }
    
    func checkIfSorted(_ number: Int) -> Bool {
            sortedNumbers.contains(number)
        }
    
    
    // NewTurn functions
    
    mutating func callNewTurn() {
        sortNumber()
        
        if checkVictory() {
            triggerVictory()
            emptySortedNumbers()
        }
        
    }
    
    func checkVictory() -> Bool {
        return checkRow() || checkColumn() || checkDiagonal()
    }
    
    mutating func triggerVictory(){
        victoryMessage = "BINGOOOU!"
        triggerHapticFeedback()
    }
    
    func triggerHapticFeedback() {
        let impactGenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactGenerator.impactOccurred()
    }
    
    mutating func emptySortedNumbers() {
        sortedNumbers.removeAll()
    }
    
    
    // Check Victory Functions
    func checkRow() -> Bool {
        for row in matrix {
            if row.allSatisfy({ $0 == nil || checkIfSorted($0!) }) {
                return true
            }
        }
        return false
    }
    
    func checkColumn() -> Bool {
            for col in 0..<5 {
                var complete = true
                for row in 0..<5 {
                    if let number = matrix[row][col], !checkIfSorted(number) {
                        complete = false
                        break
                    }
                }
                if complete { return true }
            }
            return false
        }
    
    func checkDiagonal() -> Bool {
        // Diagonal principal (canto superior esquerdo para inferior direito)
                let mainDiagonal = (0..<5).allSatisfy { index in
                    guard let number = matrix[index][index] else { return true } // Espaço livre
                    return checkIfSorted(number)
                }
                
                // Diagonal secundária (canto superior direito para inferior esquerdo)
                let secondaryDiagonal = (0..<5).allSatisfy { index in
                    guard let number = matrix[index][4 - index] else { return true }
                    return checkIfSorted(number)
                }
                
                return mainDiagonal || secondaryDiagonal
    }
    
}
