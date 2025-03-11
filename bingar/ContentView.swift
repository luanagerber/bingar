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
                    .foregroundStyle(.gray)
                Text("Scanear Cartela")
                    .bold()
                
                
                Spacer()
                
                HStack(spacing: 24){
                    VStack(spacing: 12){
                        BingoTitle(text: "B")
                        BingoNumber(number: 1)
                        BingoNumber(number: 2)
                        BingoNumber(number: 3)
                        BingoNumber(number: 4)
                        BingoNumber(number: 5)
                    }
                    
                    VStack(spacing: 12){
                        BingoTitle(text: "I")
                        BingoNumber(number: 6)
                        BingoNumber(number: 7)
                        BingoNumber(number: 8)
                        BingoNumber(number: 9)
                        BingoNumber(number: 10)
                    }
                    
                    VStack(spacing: 12){
                        BingoTitle(text: "N")
                        BingoNumber(number: 11)
                        BingoNumber(number: 12)
                        BingoNumber(number: 13)
                        BingoNumber(number: 14)
                        BingoNumber(number: 15)
                    }
                    VStack(spacing: 12){
                        BingoTitle(text: "G")
                        BingoNumber(number: 16)
                        BingoNumber(number: 17)
                        BingoNumber(number: 18)
                        BingoNumber(number: 19)
                        BingoNumber(number: 20)
                    }
                    VStack(spacing: 12){
                        BingoTitle(text: "O")
                        BingoNumber(number: 21)
                        BingoNumber(number: 22)
                        BingoNumber(number: 23)
                        BingoNumber(number: 24)
                        BingoNumber(number: 25)
                    }
                }
                
                Spacer()
            }
            .padding()
            
        }

    }
}

#Preview {
    ContentView()
}
