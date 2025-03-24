//
//  BingoNumberPosition.swift
//  VisionRectangles
//
//  Created by Luana Gerber on 24/03/25.
//

import Foundation
import SwiftUI

struct BingoNumberPosition {
    let middleX: CGFloat
    let middleY: CGFloat
    let width: CGFloat
    let height: CGFloat
}

let predefinedPositions: [BingoNumberPosition] = [
    // Coluna 1
    BingoNumberPosition(middleX: 151.63, middleY: 1130, width: 150, height: 155),
    BingoNumberPosition(middleX: 151.63, middleY: 940, width: 150, height: 155),
    BingoNumberPosition(middleX: 151.63, middleY: 750, width: 150, height: 155),
    BingoNumberPosition(middleX: 151.63, middleY: 560, width: 150, height: 155),
    BingoNumberPosition(middleX: 151.63, middleY: 372, width: 150, height: 155),
    
    // Coluna 2
    BingoNumberPosition(middleX: 361.16, middleY: 1130, width: 150, height: 155),
    BingoNumberPosition(middleX: 361.16, middleY: 940, width: 150, height: 155),
    BingoNumberPosition(middleX: 361.16, middleY: 750, width: 150, height: 155),
    BingoNumberPosition(middleX: 361.16, middleY: 560, width: 150, height: 155),
    BingoNumberPosition(middleX: 361.16, middleY: 372, width: 150, height: 155),

    // Coluna 3
    BingoNumberPosition(middleX: 595.50, middleY: 1130, width: 150, height: 155),
    BingoNumberPosition(middleX: 595.50, middleY: 940, width: 150, height: 155),
    BingoNumberPosition(middleX: 595.50, middleY: 750, width: 150, height: 155), // Espaço livre (Free Space)
    BingoNumberPosition(middleX: 595.50, middleY: 560, width: 150, height: 155),
    BingoNumberPosition(middleX: 595.50, middleY: 372, width: 150, height: 155),

    // Coluna 4
    BingoNumberPosition(middleX: 818.81, middleY: 1130, width: 150, height: 155),
    BingoNumberPosition(middleX: 822.95, middleY: 940, width: 150, height: 155),
    BingoNumberPosition(middleX: 825.70, middleY: 750, width: 150, height: 155),
    BingoNumberPosition(middleX: 825.70, middleY: 560, width: 150, height: 155),
    BingoNumberPosition(middleX: 828.00, middleY: 372, width: 150, height: 155),

    // Coluna 5
    BingoNumberPosition(middleX: 1046.26, middleY: 1130, width: 150, height: 155),
    BingoNumberPosition(middleX: 1046.26, middleY: 940, width: 150, height: 155),
    BingoNumberPosition(middleX: 1046.26, middleY: 750, width: 150, height: 155),
    BingoNumberPosition(middleX: 1046.26, middleY: 560, width: 150, height: 155),
    BingoNumberPosition(middleX: 1046.26, middleY: 372, width: 150, height: 155)
]

