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
    
    var body: some View {
        ZStack {
            CameraController(isShown: $isShown, capturedImage: $capturedImage)
            
            VStack {
                HStack {
                    Button(action: {
                        isShown = false // This will dismiss the camera view
                    }) {
                        Image(systemName: "arrow.backward.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
//                            .padding()
                    }
                    
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct CameraController: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var capturedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isShown: $isShown, capturedImage: $capturedImage)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var isShown: Bool
        @Binding var capturedImage: UIImage?
        
        init(isShown: Binding<Bool>, capturedImage: Binding<UIImage?>) {
            _isShown = isShown
            _capturedImage = capturedImage
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                capturedImage = image
                saveImageToDocumentsDirectory(image)
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


