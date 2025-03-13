//
//  BingoModel.swift
//  bingar
//
//  Created by Luana Gerber on 13/03/25.
//

import Foundation

struct BingoModel {
    
    var matrix: [[Int?]] = [
        [8,  6,  15, 14, 13],  // Coluna B
        [23, 16, 27, 26, 22],  // Coluna I
        [36, 43, nil, 33, 41], // Coluna N (com espaço livre)
        [53, 51, 58, 57, 60],  // Coluna G
        [66, 71, 65, 75, 64]   // Coluna O
    ]
    
    var activeNumbers: Set<Int> = [16, 65] // Guarda os números sorteados

    func isActive(_ number: Int) -> Bool {
            activeNumbers.contains(number)
        }
    
}
