//
//  BingoCard.swift
//  bingar
//
//  Created by Luana Gerber on 19/03/25.
//

import Foundation

struct BingoNumbers {
    var numbers: [[Int?]] = Array(repeating: Array(repeating: nil, count: 5), count: 5)
}

// Estrutura que cria uma matriz baseada em BingoNumbers
struct BingoCard {
    var matrix: [[Int?]]
    
    init(from numbers: BingoNumbers) {
        self.matrix = numbers.numbers
    }
}
