//
//  CameraView.swift
//  bingar
//
//  Created by Luana Gerber on 13/03/25.
//

import UIKit
import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @Binding var isShown: Bool
    @Binding var image: CIImage?
    @Binding var detectedObject: [DetectedObject]?
    
    var body: some View {
        GeometryReader { geometry in
            if let ciImage = image, let image = CIContext().createCGImage(ciImage, from: ciImage.extent) {
               
                VStack {
                    ZStack {
                        Image(decorative: image, scale: 1)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height)
                        
                        
                        if let detectedObject = detectedObject {
                            ForEach(detectedObject) { object in
                                BoundingBoxView(object: object)
                            }
                        }
                        
                    }
                }
                
            } else {
                ContentUnavailableView("No camera feed", systemImage: "xmark.circle.fill")
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
            }
        }
    }
    
}

struct BoundingBoxView: View {
    let object: DetectedObject
    
    var body: some View {
        Rectangle()
            .stroke(Color.green, lineWidth: 2)
            .frame(width: object.boundingBox.width * 1.2,
                   height: object.boundingBox.height * 1.3)
            .position(x: (object.boundingBox.midX - object.boundingBox.width / 2) * 1.32,
                      y: object.boundingBox.maxY + object.boundingBox.height / 2)
            .overlay(
                Text("\(object.label) (\(Int(object.confidence * 100))%)")
                    .padding(4)
                    .background(Color.green.opacity(0.5))
                    .foregroundColor(.white)
                    .font(.caption)
            )
    }
}



