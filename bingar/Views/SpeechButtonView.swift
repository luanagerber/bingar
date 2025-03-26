//
//  SpeechButtonView.swift
//  bingar
//
//  Created by Luana Gerber on 25/03/25.
//

import SwiftUI

struct SpeechButtonView: View {
    
    @ObservedObject var speechViewModel = SpeechViewModel()
    @EnvironmentObject var bingoViewModel: BingoViewModel
    
    var body: some View {
        Button(action: {
            speechViewModel.handleButtonTap(bingoViewModel: bingoViewModel)
        }) {
            Image(systemName: speechViewModel.isRecording ? "stop.circle" : "mic.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .fontWeight(.light)
                .foregroundColor(speechViewModel.isRecording ? .pink : .black.opacity(0.7))
        }
    }
}
