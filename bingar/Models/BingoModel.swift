//
//  BingoModel.swift
//  bingar
//
//  Created by Luana Gerber on 13/03/25.
//

import Foundation
import UIKit

class BingoModel: ObservableObject {
    @Published var bingoNumbers: BingoNumbers
    @Published var bingoCard: BingoCard
    
    @Published var sortedNumbers: Set<Int> = []
    @Published var victoryMessage: String = ""
    
    init() {
        let initialNumbers = BingoNumbers()
        self.bingoNumbers = initialNumbers
        self.bingoCard = BingoCard(from: initialNumbers)
    }
    
    // Sort functions
    func sortNumber() {
        var number = Int.random(in: 1...75)
        
        while sortedNumbers.contains(number) {
            number = Int.random(in: 1...75)
        }
        
        sortedNumbers.insert(number)
        print(number)
    }
    
    func checkIfSorted(_ number: Int) -> Bool {
        sortedNumbers.contains(number)
    }
    
    // NewTurn functions
    func callNewTurn() {
        sortNumber()
        
        if checkVictory() {
            triggerVictory()
        }
    }
    
    func checkVictory() -> Bool {
        return checkRow() || checkColumn() || checkDiagonal()
    }
    
    func triggerVictory() {
        victoryMessage = "BINGOOOU!"
        triggerHapticFeedback()
    }
    
    func triggerHapticFeedback() {
        let impactGenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactGenerator.impactOccurred()
    }
    
    // Check Victory Functions
    func checkRow() -> Bool {
        for row in bingoCard.matrix {
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
                if let number = bingoCard.matrix[row][col], !checkIfSorted(number) {
                    complete = false
                    break
                }
            }
            if complete { return true }
        }
        return false
    }
    
    func checkDiagonal() -> Bool {
        let mainDiagonal = (0..<5).allSatisfy { index in
            guard let number = bingoCard.matrix[index][index] else { return true } // Espaço livre
            return checkIfSorted(number)
        }
        
        let secondaryDiagonal = (0..<5).allSatisfy { index in
            guard let number = bingoCard.matrix[index][4 - index] else { return true }
            return checkIfSorted(number)
        }
        
        return mainDiagonal || secondaryDiagonal
    }
    
    func emptySortedNumbers() {
        sortedNumbers.removeAll()
    }
    
    func updateNumbers(newNumbers: [[Int?]]) {
        guard newNumbers.count == 5, newNumbers.allSatisfy({ $0.count == 5 }) else {
            print("Erro: A matriz deve ser 5x5")
            return
        }
        
        bingoNumbers.numbers = newNumbers
        bingoCard = BingoCard(from: bingoNumbers)
    }
}
