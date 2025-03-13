//
//  ContentView.swift
//  bingar
//
//  Created by Luana Gerber on 11/03/25.
//

import SwiftUI

struct HomeView: View {
    
    let bingoModel = BingoModel()

    var body: some View {

        ZStack {
            Color.green.opacity(0.3).edgesIgnoringSafeArea(.all)
            Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                ZStack{
                    Rectangle()
                        .fill(Color.white)
                        .padding(16)
                    
                HStack(spacing: 24){
                    let titles = ["B", "I", "N", "G", "O"]

                                            // Criando as colunas dinamicamente
                                            ForEach(0..<5, id: \.self) { column in
                                                VStack(spacing: 12) {
                                                    BingoTitle(text: titles[column]) // Título da coluna

                                                    // Percorrendo os números da coluna
                                                    ForEach(0..<5, id: \.self) { line in
                                                        if let number = bingoModel.matrix[column][line] {
                                                            BingoNumber(number: number, isActive: bingoModel.isActive(number))
                                                        } else {
                                                            BingoSymbol(symbol: "star") // Espaço livre no centro
                                                        }
                                                    }
                                                }
                                            }
                                        }
                }.frame(width: 350, height: 380)
                
                Spacer()
                
                HStack(spacing: 50){
                    Spacer()

                    Image(systemName: "camera.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .fontWeight(.light)
                        .foregroundStyle(.black.opacity(0.7))
                    
                    
                    AudioRecordButton()
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
