//
//  ContentView.swift
//  bingar
//
//  Created by Luana Gerber on 11/03/25.
//

import SwiftUI
import ConfettiSwiftUI

struct InitialView: View {
    
    @StateObject private var viewModel = InitialViewModel()
    @StateObject private var speechViewModel = SpeechViewModel()
    
    var body: some View {
        
        ZStack {
            Color.white.opacity(1.0).edgesIgnoringSafeArea(.all)
            Color.green.opacity(0.3).edgesIgnoringSafeArea(.all)
            Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            VStack{
                Text(viewModel.bingoViewModel.victoryMessage)
                    .font(.largeTitle)
                    .foregroundStyle(.pink)
                    .fontWeight(.semibold)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                
                Spacer()
            }
            
            VStack {
                
                Spacer()
                
                BingoGridView()
                    .confettiCannon(trigger: $viewModel.showConfetti, num: 50, openingAngle: .degrees(0), closingAngle: .degrees(360), radius: 200)
                
                HStack{
                    Spacer()
                    
                    if speechViewModel.extractedNumber != 0 {
                        Text("\(speechViewModel.extractedNumber)")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                    
                    Spacer()
                    
                }.frame(width: 350, height: 50)
                    .padding()
                
                Spacer()
                
                HStack(spacing: 70){
                    Spacer()
                    
                    CameraButtonView(cameraViewModel: $viewModel.cameraViewModel)
                    
                    Button(action: {
                        viewModel.newTurn()
                    }) {
                        Image(systemName: "laser.burst")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .fontWeight(.light)
                            .foregroundStyle(.black.opacity(0.7))
                    }
                    
                    SpeechButtonView(speechViewModel: speechViewModel)
                    
                    Spacer()
                    
                }.padding()
            }
            .padding()
        }
        .environmentObject(viewModel.bingoViewModel)
        .onChange(of: viewModel.cameraViewModel.thumbnailUIImage) {
            
            if let uiImage = viewModel.cameraViewModel.thumbnailUIImage {
                viewModel.processImageToNumbers(uiImage)
            }
        }
    }
    
}

#Preview {
    InitialView()
}
