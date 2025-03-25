//
//  CameraManager.swift
//  bingar
//
//  Created by Luana Gerber on 13/03/25.
//

import SwiftUI
import AVFoundation

struct CameraButton: View {
    @State private var isShowingCamera = false
    @State private var capturedImage: UIImage?
    
    var bingoModel: BingoViewModel
    
    var body: some View {
        Button(action: {
            openCamera()
        }) {
            Image(systemName: "camera.circle")
                .resizable()
                .frame(width: 50, height: 50)
                .fontWeight(.light)
                .foregroundStyle(.black.opacity(0.7))
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            CameraView(isShown: $isShowingCamera, capturedImage: $capturedImage, bingoModel: bingoModel)
        }
    }
    
    func openCamera() {
        isShowingCamera = true
    }
    
}
