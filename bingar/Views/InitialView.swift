//
//  ContentView.swift
//  bingar
//
//  Created by Luana Gerber on 11/03/25.
//

import SwiftUI
import ConfettiSwiftUI

struct InitialView: View {
    
    @StateObject private var bingoViewModel = BingoGridViewModel()
    @State private var cameraViewModel = CameraViewModel()
        
    @State private var showConfetti = false
    
    var body: some View {
        
        ZStack {
            Color.white.opacity(1.0).edgesIgnoringSafeArea(.all)
            Color.green.opacity(0.3).edgesIgnoringSafeArea(.all)
            Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            VStack{
                Text(bingoViewModel.victoryMessage)
                    .font(.largeTitle)
                    .foregroundStyle(.pink)
                    .fontWeight(.semibold)
                    .padding(.top, 70)
                
                Spacer()
            }
            
            VStack {
                
                Spacer()
                
                BingoGridView(bingoViewModel: bingoViewModel)
                    .confettiCannon(trigger: $showConfetti, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                
                Spacer()
                
                HStack{
                    if let cgImage = cameraViewModel.thumbnailCGImage {
                        Image(decorative: cgImage, scale: 0.5, orientation: .right)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(.bottom, 20)
                    }
                    
                    Spacer()
                                        
                }
                
                HStack(spacing: 70){
                    Spacer()
                    
                    CameraButtonView(cameraViewModel: $cameraViewModel)
                    
                    Button(action: {
                        bingoViewModel.callNewTurn()
                        if bingoViewModel.checkVictory(){
                            showConfetti = true
                        }
                    }) {
                        Image(systemName: "laser.burst")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .fontWeight(.light)
                            .foregroundStyle(.black.opacity(0.7))
                    }
                    
                    SpeechButtonView()
                    
                    Spacer()
                    
                }.padding()
            }
            .padding()
        }
        .environmentObject(bingoViewModel)
    }
    
}

#Preview {
    InitialView()
}
