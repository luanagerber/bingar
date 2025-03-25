//
//  DetectorService.swift
//  bingar
//
//  Created by Jaide Zardin on 19/03/25.
//

import SwiftUI
import CoreML
import AVFoundation

struct DetectorService {
    
    private var model: BingoCardsDetector!
    
    init() {
        do {
            let config = MLModelConfiguration()
            model = try BingoCardsDetector(configuration: config)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func predict(image: CIImage) -> [DetectedObject] {
        
        let uiImage = UIImage(ciImage: image)
        guard let newImage = uiImage.resizeImageTo(size: .init(width: 299, height: 299)) else { return [] }
        
        guard let cgImage = convertUIImageToCGImage(input: newImage) else { return [] }
        
        guard let output = try? model.prediction(input: .init(imagePathWith: cgImage)) else {
            print("adsasdsad")
            return []
        }
        
        var detectedOBjects: [DetectedObject] = []
        let boundingBoxes = processPredictions(coordinates: output.coordinates, cameraSize: .init(width: image.extent.width, height: image.extent.height))
        
        if boundingBoxes.isEmpty {
            return [DetectedObject(label: "", confidence: 0, boundingBox: .zero)]
        }
        
        for box in boundingBoxes {
            let detectedObject = DetectedObject(label: "Bingo", confidence: 1.0, boundingBox: box)
            detectedOBjects.append(detectedObject)
        }
        return detectedOBjects
        
    }
    
    func convertUIImageToCGImage(input: UIImage) -> CGImage! {
        guard let ciImage = CIImage(image: input) else {
            return nil
        }
        
        let context = CIContext(options: nil)
        return context.createCGImage(ciImage, from: ciImage.extent)
    }
    
    func processPredictions(coordinates: MLMultiArray, cameraSize: CGSize, modelInputSize: CGSize = CGSize(width: 299, height: 299)) -> [CGRect] {
        var rects: [CGRect] = []
        let boxCount = coordinates.shape[0].intValue
        let boxElements = coordinates.shape[1].intValue // Deve ser 4 (x, y, width, height)

        assert(boxElements == 4, "Esperado shape (N, 4) nas coordenadas")

        var scaleX = cameraSize.width / modelInputSize.width
        var scaleY = cameraSize.height / modelInputSize.height
        
        scaleX = 1 / scaleX
        scaleY = 1 / scaleY

        for i in 0..<boxCount {
            let baseIndex = i * boxElements
            
            let x = coordinates[baseIndex].doubleValue
            let y = coordinates[baseIndex + 1].doubleValue
            let width = coordinates[baseIndex + 2].doubleValue
            let height = coordinates[baseIndex + 3].doubleValue

            let rect = CGRect(
                x: CGFloat(x) * scaleX * cameraSize.width,
                y: CGFloat(y) * scaleY * cameraSize.height,
                width: CGFloat(width) * scaleX * cameraSize.width,
                height: CGFloat(height) * scaleY * cameraSize.height
            )
            rects.append(rect)
        }
        return rects
    }
    
    mutating func resizeImage(_ image: UIImage, to targetSize: CGSize = .init(width: 299, height: 299)) -> UIImage {
        
        if let newImage = image.resizeImageTo(size: targetSize) {
            return newImage
        } else {
            return image
        }
    }
}

extension UIImage {
    
    func resizeImageTo(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func convertToBuffer() -> CVPixelBuffer? {
        
        let attributes = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault, Int(self.size.width),
            Int(self.size.height),
            kCVPixelFormatType_32ARGB,
            attributes,
            &pixelBuffer)
        
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(
            data: pixelData,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
