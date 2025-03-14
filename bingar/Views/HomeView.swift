//
//  ContentView.swift
//  bingar
//
//  Created by Luana Gerber on 11/03/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var bingoModel = BingoModel()
        
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
                    
                    HStack(spacing: 24){
                        let titles = ["B", "I", "N", "G", "O"]
                        
                        ForEach(0..<5, id: \.self) { column in
                            VStack(spacing: 12) {
                                BingoTitle(text: titles[column]) // Título da coluna
                                
                                // Percorrendo os números da coluna
                                ForEach(0..<5, id: \.self) { line in
                                    if let number = bingoModel.matrix[line][column] {
                                        BingoNumber(number: number, isActive: bingoModel.checkIfSorted(number))
                                    } else {
                                        BingoSymbol(symbol: "lizard.fill") // Espaço livre no centro
                                    }
                                }
                            }
                        }
                    }
                }.frame(width: 350, height: 380)
                
                Spacer()
                
                HStack(spacing: 70){
                    Spacer()
                    
                    CameraManager()
                    
                    Button(action: {
                        bingoModel.callNewTurn()
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
            
        }
        
    }
    
}

#Preview {
    HomeView()
}
