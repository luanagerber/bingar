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
    @State private var capturedImage: UIImage?
    
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
            CameraView(isShown: $isShowingCamera, capturedImage: $capturedImage)
        }
    }
    
    func openCamera() {
        isShowingCamera = true
    }
}

// Extension to help with CoreML processing
extension CameraManager {
    func loadSavedImage() -> UIImage? {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageFilename = documentPath.appendingPathComponent("temp_capture.jpg")
        
        if let imageData = try? Data(contentsOf: imageFilename),
           let image = UIImage(data: imageData) {
            return image
        }
        return nil
    }
    
    func processImageWithCoreML() {
        guard let image = loadSavedImage() else {
            print("No image to process")
            return
        }
        
        // Here you would add your CoreML code to process the image
        // For example:
        // let model = YourCoreMLModel()
        // let prediction = try? model.prediction(image: image.pixelBuffer())
    }
    
    func deleteImage() {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageFilename = documentPath.appendingPathComponent("temp_capture.jpg")
        
        do {
            if FileManager.default.fileExists(atPath: imageFilename.path) {
                try FileManager.default.removeItem(at: imageFilename)
                print("Image deleted successfully")
            }
        } catch {
            print("Error deleting image: \(error.localizedDescription)")
        }
    }
}
