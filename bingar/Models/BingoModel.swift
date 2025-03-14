//
//  BingoModel.swift
//  bingar
//
//  Created by Luana Gerber on 13/03/25.
//

import Foundation

struct BingoModel {
    
    var matrix: [[Int?]] = [
        //B,  I,  N,  G,   O
        [8,  23,  36, 53, 66],
        [6, 16, 43, 51, 71],
        [15, 27, nil, 58, 65],
        [14, 26, 33, 57, 75],
        [13, 22, 41, 60, 64]
    ]
    
    var sortedNumbers: Set<Int> = [16, 33, 65, 99, 103] // Guarda os números sorteados

    func wasSorted(_ number: Int) -> Bool {
            sortedNumbers.contains(number)
        }
    
    func checkVictory() -> Bool {
        return checkRow() || checkColumn() || checkDiagonal()
    }
    
    func checkRow() -> Bool {
        for row in matrix {
            if row.allSatisfy({ $0 == nil || wasSorted($0!) }) {
                return true
            }
        }
        return false
    }
    
    func checkColumn() -> Bool {
            for col in 0..<5 {
                var complete = true
                for row in 0..<5 {
                    if let number = matrix[row][col], !wasSorted(number) {
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
                    return wasSorted(number)
                }
                
                // Diagonal secundária (canto superior direito para inferior esquerdo)
                let secondaryDiagonal = (0..<5).allSatisfy { index in
                    guard let number = matrix[index][4 - index] else { return true }
                    return wasSorted(number)
                }
                
                return mainDiagonal || secondaryDiagonal
    }
    
}
