//
//  CameraManagerExtension.swift
//  bingar
//
//  Created by Luana Gerber on 19/03/25.
//

import SwiftUI
import AVFoundation
import CoreVideo
import UIKit

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
    
    func convertSavedImage() -> CVPixelBuffer? {
        guard let image = loadSavedImage() else {
            print("No image to convert")
            return nil
        }
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        
        let attributes: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true
        ]
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attributes as CFDictionary, &pixelBuffer)
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            print("Failed to create CVPixelBuffer")
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        let pixelData = CVPixelBufferGetBaseAddress(buffer)
        
        guard let context = CGContext(
            data: pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            return nil
        }
        
        guard let cgImage = image.cgImage else { return nil }
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(buffer, [])
        
        return buffer
    }
    
    
    func processImageWithCoreML() {
        guard let convertedImage = convertSavedImage() else {
            print("Failed to process image")
            return
        }
        
        // Add CoreML code to process the image
        let model = try? BingoCardsDetector(configuration: .init())
        
        let prediction = try? model?.prediction(image: convertedImage)
        let result = prediction?.classLabel ?? "No prediction"
        let isBingoCard = result == "bingoCard"
        
        print(isBingoCard)
        
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

