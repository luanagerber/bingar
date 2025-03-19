//
//  CameraManagerExtension.swift
//  bingar
//
//  Created by Luana Gerber on 19/03/25.
//

import SwiftUI
import AVFoundation

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
        
        // Add CoreML code to process the image
        let model = try? BingoCardsDetector(configuration: .init())
        
        let prediction = try? model.prediction(image: image)
        var result = prediction?.classLabel ?? "No prediction"
        print(result)
        
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

