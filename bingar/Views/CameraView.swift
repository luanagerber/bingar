//
//  CameraView.swift
//  bingar
//
//  Created by Luana Gerber on 13/03/25.
//

import UIKit
import SwiftUI

struct CameraView: View {
    @Binding var isShown: Bool
    @Binding var capturedImage: UIImage?
    
    var bingoModel: BingoViewModel
    
    var body: some View {
        ZStack {
            CameraController(isShown: $isShown, capturedImage: $capturedImage, bingoModel: bingoModel)
        }
    }
}

struct CameraController: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var capturedImage: UIImage?
    
    var bingoModel: BingoViewModel
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isShown: $isShown, capturedImage: $capturedImage, bingoModel: bingoModel)
    }
    
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var isShown: Bool
        @Binding var capturedImage: UIImage?
        var bingoModel: BingoViewModel
        
        init(isShown: Binding<Bool>, capturedImage: Binding<UIImage?>, bingoModel: BingoViewModel) {
            _isShown = isShown
            _capturedImage = capturedImage
            self.bingoModel = bingoModel
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                capturedImage = image
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    processImageToNumbers(in: image, bingoModel: self.bingoModel)

                }
            }
            isShown = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }
        
        private func saveImageToDocumentsDirectory(_ image: UIImage) {
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let imageFilename = documentPath.appendingPathComponent("temp_capture.jpg")
            
            if let jpegData = image.jpegData(compressionQuality: 0.8) {
                do {
                    try jpegData.write(to: imageFilename)
                    print("Image saved to: \(imageFilename.path)")
                } catch {
                    print("Error saving image: \(error.localizedDescription)")
                }
            }
        }
    }
    
}


