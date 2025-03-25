//
//  ContentView.swift
//  bingar
//
//  Created by Luana Gerber on 11/03/25.
//

import SwiftUI
import ConfettiSwiftUI

struct HomeView: View {
    
    @StateObject private var bingoModel = BingoViewModel()
    
//    @State private var showConfetti = false
    
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
                
                BingoGridView(bingoModel: bingoModel)
                
                Spacer()
                
                HStack(spacing: 70){
                    Spacer()
                    
                    CameraButton(bingoModel: bingoModel)
                    
                    Button(action: {
                        bingoModel.callNewTurn()
                        if bingoModel.checkVictory(){
//                            showConfetti = true
                        }
                    }) {
                        Image(systemName: "laser.burst")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .fontWeight(.light)
                            .foregroundStyle(.black.opacity(0.7))
                    }
                    
                    SpeechButton(bingoModel: bingoModel)
                    
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
