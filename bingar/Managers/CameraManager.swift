//
//  CameraManager.swift
//  bingar
//
//  Created by Luana Gerber on 13/03/25.
//

import SwiftUI
import AVFoundation

struct CameraManager: View {
    @State private var isShowingCamera = false
    
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
            CameraView(isShown: $isShowingCamera)
        }
    }
    
    func openCamera() {
        isShowingCamera = true
    }
}
