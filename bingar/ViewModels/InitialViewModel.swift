//
//  InitialViewModel.swift
//  bingar
//
//  Created by Luana Gerber on 25/03/25.
//

import SwiftUI

class InitialViewModel: ObservableObject {
    
    @Published var bingoViewModel = BingoViewModel()
    @Published var cameraViewModel = CameraViewModel()
    @Published var showConfetti = false
    
    func newTurn() {
        bingoViewModel.callNewTurn()
        if bingoViewModel.checkVictory() {
            showConfetti = true
        }
    }
}
