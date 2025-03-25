//
//  CameraManager.swift
//  bingar
//
//  Created by Luana Gerber on 13/03/25.
//

import SwiftUI
import AVFoundation

struct CameraButtonView: View {
    @State private var isShowingCamera = false
    @State private var capturedImage: UIImage?
    
    @Binding var cameraViewModel: CameraViewModel
    @EnvironmentObject var bingoViewModel: BingoGridViewModel
        
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
            CameraView(isShown: $isShowingCamera, image: $cameraViewModel.currentFrame, detectedObject: $cameraViewModel.detectedObject)
            
            Button {
                cameraViewModel.cameraManager.takePhoto()
                withAnimation {
                    isShowingCamera = false
                }
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
        }
    }
    
    func openCamera() {
        isShowingCamera = true
    }
    
}
