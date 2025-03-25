//
//  ObjectDetector.swift
//  BingoDetectorTest
//
//  Created by Jaide Zardin on 21/03/25.
//

import CoreGraphics
import Foundation

struct DetectedObject: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let confidence: Float
    let boundingBox: CGRect
}
