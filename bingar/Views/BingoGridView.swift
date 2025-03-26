//
//  BingoGridView.swift
//  bingar
//
//  Created by Luana Gerber on 25/03/25.
//


import SwiftUI

struct BingoGridView: View {
    
//    @ObservedObject var bingoViewModel: BingoViewModel
    @EnvironmentObject var bingoViewModel: BingoViewModel

    let elementWidht: CGFloat = 47
    let elementHeight: CGFloat = 41
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .fill(Color.white)
                .padding(16)
                .shadow(radius: 2)
            
            VStack(spacing: 6.5) {
                HStack(spacing: 12){
                    BingoTitle(text: "B")
                        .frame(width: elementWidht, height: elementHeight, alignment: .center)
                    BingoTitle(text: "I")
                        .frame(width: elementWidht, height: elementHeight, alignment: .center)
                    BingoTitle(text: "N")
                        .frame(width: elementWidht, height: elementHeight, alignment: .center)
                    BingoTitle(text: "G")
                        .frame(width: elementWidht, height: elementHeight, alignment: .center)
                    BingoTitle(text: "O")
                        .frame(width: elementWidht, height: elementHeight, alignment: .center)
                }.padding(.top, 2)
                
                ForEach(0..<5, id: \.self) { column in
                    HStack(spacing: 12) {
                        // Percorrendo os números da coluna
                        ForEach(0..<5, id: \.self) { line in
                            if let number = bingoViewModel.bingoCard.matrix[line][column] {
                                BingoNumber(number: number, isActive: bingoViewModel.checkIfSorted(number))
                                    .frame(width: elementWidht, height: elementHeight, alignment: .center)
                            } else {
                                BingoSymbol(symbol: "lizard.fill") // Espaço livre no centro
                                    .frame(width: elementWidht, height: elementHeight, alignment: .center)
                            }
                        }
                    }
                }
                
            }
        }.frame(width: 350, height: 380)
        
    }
}
