//
//  InitialViewModel.swift
//  bingar
//
//  Created by Luana Gerber on 25/03/25.
//

import SwiftUI

class InitialViewModel: ObservableObject {
    
    @Published var bingoViewModel: BingoViewModel
    @Published var cameraViewModel: CameraViewModel
    @Published var bingoNumbersExtractor: BingoNumbersExtractor
    
    @Published var showConfetti = false
        

    init() {
        self.bingoViewModel = BingoViewModel()
        self.cameraViewModel = CameraViewModel()
        self.bingoNumbersExtractor = BingoNumbersExtractor()
    }
    
    func processImageToNumbers(_ image: UIImage) {
        bingoNumbersExtractor.processImageToNumbers(in: image, bingoModel: bingoViewModel)
    }
    
    func newTurn() {
        bingoViewModel.callNewTurn()
        if bingoViewModel.checkVictory() {
            showConfetti = true
        }
    }
}
