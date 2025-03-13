//
//  ContentView.swift
//  bingar
//
//  Created by Luana Gerber on 11/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        ZStack {
            
            Color.green.opacity(0.3).edgesIgnoringSafeArea(.all)
            Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "camera")
                    .imageScale(.large)
                    .foregroundStyle(.black.opacity(0.7))
                    .padding(.bottom, 2)
                Text("Scanear Cartela")
                    .bold()
                
                
                Spacer()
                
                ZStack{
                    Rectangle()
                        .fill(Color.white)
                        .padding(16)
                    
                HStack(spacing: 24){
                    VStack(spacing: 12){
                        BingoTitle(text: "B")
                        BingoNumber(number: 8)
                        BingoNumber(number: 6)
                        BingoNumber(number: 15)
                        BingoNumber(number: 14)
                        BingoNumber(number: 13)
                    }
                    
                    VStack(spacing: 12){
                        BingoTitle(text: "I")
                        BingoNumber(number: 23)
                        BingoNumber(number: 16)
                        BingoNumber(number: 27)
                        BingoNumber(number: 26)
                        BingoNumber(number: 22)
                    }
                    
                    VStack(spacing: 12){
                        BingoTitle(text: "N")
                        BingoNumber(number: 36)
                        BingoNumber(number: 43)
                        BingoSymbol(symbol: "star")
                        BingoNumber(number: 33)
                        BingoNumber(number: 41)
                    }
                    VStack(spacing: 12){
                        BingoTitle(text: "G")
                        BingoNumber(number: 53)
                        BingoNumber(number: 51)
                        BingoNumber(number: 58)
                        BingoNumber(number: 57)
                        BingoNumber(number: 60)
                    }
                    VStack(spacing: 12){
                        BingoTitle(text: "O")
                        BingoNumber(number: 66)
                        BingoNumber(number: 71)
                        BingoNumber(number: 65)
                        BingoNumber(number: 75)
                        BingoNumber(number: 64)
                    }
                }
                }.frame(width: 350, height: 370)
                
                Spacer()
                
                Image(systemName: "microphone")
                    .imageScale(.large)
                    .foregroundStyle(.black.opacity(0.7))
                    .padding(.bottom, 2)
                Text("Gravar voz")
                    .bold()
            }
            .padding()
            
        }

    }
}

#Preview {
    ContentView()
}
