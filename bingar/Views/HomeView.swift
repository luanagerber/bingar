//
//  ContentView.swift
//  bingar
//
//  Created by Luana Gerber on 11/03/25.
//

import SwiftUI
import ConfettiSwiftUI

struct HomeView: View {
    
    @StateObject private var bingoModel = BingoModel()
    @State private var showConfetti = false
    
    let widht: CGFloat = 47
    let height: CGFloat = 41
    
    var body: some View {
        
        ZStack {
            Color.white.opacity(1.0).edgesIgnoringSafeArea(.all)
            Color.green.opacity(0.3).edgesIgnoringSafeArea(.all)
            Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            VStack{
                Text(bingoModel.victoryMessage)
                    .font(.largeTitle)
                    .foregroundStyle(.pink)
                    .fontWeight(.semibold)
                    .padding(.top, 70)
                
                Spacer()
            }
            
            VStack {
                
                Spacer()
                
                ZStack{
                    Rectangle()
                        .fill(Color.white)
                        .padding(16)
                        .shadow(radius: 2)
                    
                    VStack(spacing: 6.5) {
//                        let titles = ["B", "I", "N", "G", "O"]
                        
                        HStack(spacing: 12){
                            BingoTitle(text: "B")
                                .frame(width: widht, height: height, alignment: .center)
                            BingoTitle(text: "I")
                                .frame(width: widht, height: height, alignment: .center)
                            BingoTitle(text: "N")
                                .frame(width: widht, height: height, alignment: .center)
                            BingoTitle(text: "G")
                                .frame(width: widht, height: height, alignment: .center)
                            BingoTitle(text: "O")
                                .frame(width: widht, height: height, alignment: .center)
                        }.padding(.top, 2)
                        
                        ForEach(0..<5, id: \.self) { column in
                            HStack(spacing: 12) {
//                                BingoTitle(text: titles[column]) // Título da coluna
                                
                                // Percorrendo os números da coluna (invertendo linha e coluna)
                                ForEach(0..<5, id: \.self) { line in
                                    if let number = bingoModel.bingoCard.matrix[line][column] {
                                        BingoNumber(number: number, isActive: bingoModel.checkIfSorted(number))
                                            .frame(width: widht, height: height, alignment: .center)
                                    } else {
                                        BingoSymbol(symbol: "lizard.fill") // Espaço livre no centro
                                            .frame(width: widht, height: height, alignment: .center)
                                    }
                                     
                                }
                            }
                        }
                    }
                }.frame(width: 350, height: 380)

                Spacer()
                
                HStack(spacing: 70){
                    Spacer()
                    
                    CameraManager(bingoModel: bingoModel)
                    
                    Button(action: {
                        bingoModel.callNewTurn()
                        if bingoModel.checkVictory(){
                            showConfetti = true
                        }
                    }) {
                        Image(systemName: "laser.burst")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .fontWeight(.light)
                            .foregroundStyle(.black.opacity(0.7))
                    }
                    
                    
                    AudioRecordManager()
                    
                    Spacer()
                    
                }.padding()
                
            }
            .padding()
            
//            ConfettiCannon(trigger: $showConfetti, num: 50, confettiSize: 16, fadesOut: true)
        }
        
    }
    
}

#Preview {
    HomeView()
}
