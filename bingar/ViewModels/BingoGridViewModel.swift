//
//  BingoModel.swift
//  bingar
//
//  Created by Luana Gerber on 13/03/25.
//

import Foundation
import SwiftUI
import Vision
import UIKit

class BingoGridViewModel: ObservableObject {
    @Published var bingoNumbers: BingoNumbers
    @Published var bingoCard: BingoCard
    
    @Published var sortedNumbers: Set<Int> = []
    @Published var victoryMessage: String = ""
    @Published var extractedNumber: Int?
    
    init() {
        let initialNumbers = BingoNumbers()
        self.bingoNumbers = initialNumbers
        self.bingoCard = BingoCard(from: initialNumbers)
    }
    
    // MARK: - Atualização da cartela de Bingo
    func updateNumbers(newNumbers: [[Int?]]) {
        guard newNumbers.count == 5, newNumbers.allSatisfy({ $0.count == 5 }) else {
            print("Erro: A matriz deve ser 5x5")
            return
        }
        
        DispatchQueue.main.async {
            self.emptySortedNumbers()
            self.bingoNumbers.numbers = newNumbers
            self.bingoCard = BingoCard(from: self.bingoNumbers)
        }
    }
    
    // MARK: - Sorteio de números
    func sortNumber() {
        var number = Int.random(in: 1...75)
        
        while sortedNumbers.contains(number) {
            number = Int.random(in: 1...75)
        }
        
        sortedNumbers.insert(number)
        print(number)
    }
    
    func addSortedNumber(number: Int) {
        if number != 0 && !sortedNumbers.contains(number) {
            sortedNumbers.insert(number)
        }
    }
    
    func checkIfSorted(_ number: Int) -> Bool {
        sortedNumbers.contains(number)
    }
    
    // MARK: - Novo Turno
    func callNewTurn() {
        sortNumber()
        
        if checkVictory() {
            triggerVictory()
        }
    }
    
    // MARK: - Verificação de Vitória
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
            guard let number = bingoCard.matrix[index][index] else { return true }
            return checkIfSorted(number)
        }
        
        let secondaryDiagonal = (0..<5).allSatisfy { index in
            guard let number = bingoCard.matrix[index][4 - index] else { return true }
            return checkIfSorted(number)
        }
        
        return mainDiagonal || secondaryDiagonal
    }
    
    // MARK: - Reset do Bingo
    func emptySortedNumbers() {
        sortedNumbers.removeAll()
    }
}
