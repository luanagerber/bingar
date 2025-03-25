//
//  CameraViewModel.swift
//  BingoDetectorTest
//
//  Created by Jaide Zardin on 19/03/25.
//

import Foundation
import CoreImage
import Observation
import UIKit
import AVFoundation
import SwiftUI


@Observable
class CameraViewModel {
    
    var currentFrame: CIImage?
    var detectedObject: [DetectedObject]?
    let cameraManager = CameraManager()
    private var objectDetector = DetectorService()
    var thumbnailImage: Image?
    var thumbnailUIImage: UIImage? = nil
    var thumbnailCGImage: CGImage? = nil {
        didSet {
            if let cgImage = thumbnailCGImage {
                thumbnailUIImage = UIImage(cgImage: cgImage)
            }
        }
    }
    
    init() {
        Task {
            await handleCameraPreviews()
        }
        
        Task {
            await handleCameraPhotos()
        }
    }
    
    func handleCameraPreviews() async {
        
        await cameraManager.start()
        
        for await image in cameraManager.previewStream {
            Task { @MainActor in
                currentFrame = image
                
                processFrame()
            }
        }
    }
    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = cameraManager.photoStream
            .compactMap { self.unpackPhoto($0) }
        
        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                thumbnailImage = photoData.thumbnailImage
            }
        }
    }
    
    func processFrame() {
        if let image = currentFrame {
            detectedObject = objectDetector.predict(image:  image)
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
        guard let imageData = photo.fileDataRepresentation() else { return nil }

        guard let previewCGImage = photo.previewCGImageRepresentation(),
           let metadataOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
              let cgImageOrientation = CGImagePropertyOrientation(rawValue: metadataOrientation) else { return nil }
        let imageOrientation = Image.Orientation.right
        let thumbnailImage = Image(decorative: previewCGImage, scale: 1, orientation: imageOrientation)
        
        thumbnailCGImage = previewCGImage
        
        let photoDimensions = photo.resolvedSettings.photoDimensions
        let imageSize = (width: Int(photoDimensions.width), height: Int(photoDimensions.height))
        let previewDimensions = photo.resolvedSettings.previewDimensions
        let thumbnailSize = (width: Int(previewDimensions.width), height: Int(previewDimensions.height))
        
        return PhotoData(thumbnailImage: thumbnailImage, thumbnailSize: thumbnailSize, imageData: imageData, imageSize: imageSize)
    }
}

fileprivate struct PhotoData {
    var thumbnailImage: Image
    var thumbnailSize: (width: Int, height: Int)
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension Image.Orientation {

    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
