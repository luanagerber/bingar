//
//  CameraManager.swift
//  BingoDetectorTest
//
//  Created by Jaide Zardin on 24/03/25.
//

import AVFoundation
import SwiftUI
import CoreImage
import os

/// A comprehensive manager for handling camera functionality, including video preview, photo capture, device switching, and orientation updates.
/// It leverages an AVCaptureSession to manage camera input and outputs.
class CameraManager: NSObject {
    // MARK: - Session and Device Management
    
    /// The capture session that streams data from the camera.
    private let captureSession = AVCaptureSession()
    /// Flag indicating if the capture session has been configured.
    private var isCaptureSessionConfigured = false
    /// The current device input used for capturing video.
    private var deviceInput: AVCaptureDeviceInput?
    /// The output used for capturing photos.
    private var photoOutput: AVCapturePhotoOutput?
    /// The output used for delivering video frames.
    private var videoOutput: AVCaptureVideoDataOutput?
    
    /// A serial queue on which all session operations are performed.
    private var sessionQueue: DispatchQueue = .init(label: "video.preview.session")
    
    
    //MARK: Capture Devices
    /// Returns all capture devices for video, including TrueDepth, Dual, Wide-Angle, etc.
    private var allCaptureDevices: [AVCaptureDevice] {
        #if os(iOS)
        AVCaptureDevice.DiscoverySession(
            deviceTypes: [
                .builtInTrueDepthCamera,
                    .builtInDualCamera,
                    .builtInDualWideCamera,
                    .builtInWideAngleCamera,
                    .builtInDualWideCamera
            ],
            mediaType: .video,
            position: .unspecified
        ).devices
        #elseif os(macOS)
        AVCaptureDevice.DiscoverySession(
            deviceTypes: [
                .builtInWideAngleCamera,
                .continuityCamera,
                .deskViewCamera
            ],
            mediaType: .video,
            position: .unspecified
        ).devices
        #endif
    }
    
    #if os(iOS)
    /// Available front-facing capture devices.
    private var frontCaptureDevices: [AVCaptureDevice] { allCaptureDevices.filter { $0.position == .front } }
    /// Available back-facing capture devices.
    private var backCaptureDevices: [AVCaptureDevice] { allCaptureDevices.filter { $0.position == .back } }
    #endif
    
    /// Determines the preferred capture devices based on platform.
    private var captureDevices: [AVCaptureDevice] {
        var devices = [AVCaptureDevice]()
        #if os(macOS) || (os(iOS) && targetEnvironment(macCatalyst))
        devices += allCaptureDevices
        #else
        // For standard iOS devices, prefer back camera first then front.
        if let backDevice = backCaptureDevices.first {
            devices.append(backDevice)
        }
        if let frontDevice = frontCaptureDevices.first {
            devices.append(frontDevice)
        }
        #endif
        return devices
    }
    
    /// Filters capture devices that are connected and active.
    private var availableCaptureDevices: [AVCaptureDevice] {
        captureDevices.filter { $0.isConnected && !$0.isSuspended }
    }
    
    /// The currently selected capture device. When updated, the session configuration is refreshed.
    private var captureDevice: AVCaptureDevice? {
        didSet {
            guard let captureDevice = captureDevice else { return }
            logger.debug("Using capture device: \(captureDevice.localizedName)")
            sessionQueue.async {
                self.updateSessionForCaptureDevice(captureDevice)
            }
        }
    }
    
    #if os(iOS)
    /// Returns true if the front capture device is currently used.
    var isUsingFrontCaptureDevice: Bool {
        guard let captureDevice = captureDevice else { return false }
        return frontCaptureDevices.contains(captureDevice)
    }
    
    /// Returns true if the back capture device is currently used.
    var isUsingBackCaptureDevice: Bool {
        guard let captureDevice = captureDevice else { return false }
        return backCaptureDevices.contains(captureDevice)
    }
    #endif
    
    /// Indicates if the capture session is currently running.
    var isRunning: Bool {
        captureSession.isRunning
    }
    
    // MARK: - Preview and Photo Streams
    
    /// Closure to yield captured photos via the photo stream.
    private var addToPhotoStream: ((AVCapturePhoto) -> Void)?
    
    /// Closure to yield preview frames (as CIImage) via the preview stream.
    private var addToPreviewStream: ((CIImage) -> Void)?
    
    /// Flag to pause the preview stream if desired.
    var isPreviewPaused = false
    
    /// Asynchronous stream that delivers preview frames as CIImages.
    lazy var previewStream: AsyncStream<CIImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { ciImage in
                if !self.isPreviewPaused {
                    continuation.yield(ciImage)
                }
            }
        }
    }()
    
    /// Asynchronous stream that delivers captured photos.
    lazy var photoStream: AsyncStream<AVCapturePhoto> = {
        AsyncStream { continuation in
            addToPhotoStream = { photo in
                continuation.yield(photo)
            }
        }
    }()
    
    // MARK: - Initialization
    override init() {
        super.init()
        initialize()
    }
    
    /// Initializes the session queue, selects a default capture device, and registers for orientation notifications.
    private func initialize() {
        captureDevice = availableCaptureDevices.first ?? AVCaptureDevice.default(for: .video)
    }
    
    // MARK: - Capture Session Configuration
    
    /// Configures the capture session by setting up device input, photo output, and video output.
    /// - Parameter completionHandler: Called with a Bool indicating whether the configuration succeeded.
    private func configureCaptureSession(completionHandler: (_ success: Bool) -> Void) {
        var success = false
        
        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
            completionHandler(success)
        }
        
        guard let captureDevice = captureDevice,
              let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            logger.error("Failed to obtain video input.")
            return
        }
        
        let photoOutput = AVCapturePhotoOutput()
        captureSession.sessionPreset = .photo
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoDataOutputQueue"))
        
        guard captureSession.canAddInput(deviceInput) else {
            logger.error("Unable to add device input to capture session.")
            return
        }
        guard captureSession.canAddOutput(photoOutput) else {
            logger.error("Unable to add photo output to capture session.")
            return
        }
        guard captureSession.canAddOutput(videoOutput) else {
            logger.error("Unable to add video output to capture session.")
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(photoOutput)
        captureSession.addOutput(videoOutput)
        
        self.deviceInput = deviceInput
        self.photoOutput = photoOutput
        self.videoOutput = videoOutput
        
        photoOutput.maxPhotoQualityPrioritization = .quality
        
        updateVideoOutputConnection()
        
        isCaptureSessionConfigured = true
        success = true
    }
    
    /// Checks camera access authorization status asynchronously.
    /// - Returns: True if access is authorized, false otherwise.
    private func checkAuthorization() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            logger.debug("Camera access authorized.")
            return true
        case .notDetermined:
            logger.debug("Camera access not determined.")
            sessionQueue.suspend()
            let status = await AVCaptureDevice.requestAccess(for: .video)
            sessionQueue.resume()
            return status
        case .denied:
            logger.debug("Camera access denied.")
            return false
        case .restricted:
            logger.debug("Camera access restricted.")
            return false
        @unknown default:
            return false
        }
    }
    
    /// Updates the capture session configuration with a new capture device.
    /// - Parameter captureDevice: The new device to use.
    private func updateSessionForCaptureDevice(_ captureDevice: AVCaptureDevice) {
        guard isCaptureSessionConfigured else { return }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        // Remove existing inputs.
        for input in captureSession.inputs {
            if let deviceInput = input as? AVCaptureDeviceInput {
                captureSession.removeInput(deviceInput)
            }
        }
        
        if let deviceInput = deviceInputFor(device: captureDevice),
           captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }
        
        updateVideoOutputConnection()
    }
    
    /// Updates the video output connection settings, including mirroring if using the front camera.
    private func updateVideoOutputConnection() {
        if let videoOutput = videoOutput,
           let connection = videoOutput.connection(with: .video) {
            
            
            #if os(iOS)
            if connection.isVideoMirroringSupported {
                connection.isVideoMirrored = isUsingFrontCaptureDevice
            }
            
            if connection.isVideoRotationAngleSupported(self.deviceRotationAngle) {
                connection.videoRotationAngle = self.deviceRotationAngle
            }
            #elseif os(macOS)
            connection.isVideoMirrored = true
            #endif
        }
    }
    
    /// Returns an AVCaptureDeviceInput for the specified device.
    /// - Parameter device: The capture device to convert.
    /// - Returns: An optional device input.
    private func deviceInputFor(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let device = device else { return nil }
        do {
            return try AVCaptureDeviceInput(device: device)
        } catch let error {
            logger.error("Error getting capture device input: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Capture Session Control
    
    /// Starts the capture session after verifying authorization and configuring the session if needed.
    func start() async {
        let authorized = await checkAuthorization()
        guard authorized else {
            logger.error("Camera access was not authorized.")
            return
        }
        
        if isCaptureSessionConfigured {
            if !captureSession.isRunning {
                sessionQueue.sync {
                    self.captureSession.startRunning()
                }
            }
            return
        }
        
        sessionQueue.sync {
            self.configureCaptureSession { success in
                guard success else { return }
                self.captureSession.startRunning()
            }
        }
    }
    
    /// Stops the capture session.
    func stop() {
        guard isCaptureSessionConfigured else { return }
        if captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    /// Switches between available capture devices.
    func switchCaptureDevice() {
        if let captureDevice = captureDevice,
           let index = availableCaptureDevices.firstIndex(of: captureDevice) {
            let nextIndex = (index + 1) % availableCaptureDevices.count
            self.captureDevice = availableCaptureDevices[nextIndex]
        } else {
            self.captureDevice = AVCaptureDevice.default(for: .video)
        }
        updateVideoOutputConnection()
    }
    
    // MARK: - Device Orientation Handling
    
    #if !os(macOS)
    /// Returns the current device orientation, falling back to the screen orientation if unknown.
    private var deviceOrientation: UIDeviceOrientation {
        let orientation = UIDevice.current.orientation
        if orientation == .unknown {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                // Current orientation of the WindowScene
                return windowScene.deviceOrientation
            } else {
                // Fallback to default portrait
                return .portrait
            }
        }
        return orientation
    }
    #endif
    
    #if !os(macOS)
    /// Returns the device rotation angle, given the current device orientation
    private var deviceRotationAngle: CGFloat { deviceOrientation.videoRotationAngle }
    #endif
    
    // MARK: - Photo Capture
    
    /// Captures a still photo using the current settings.
    func takePhoto() {
        guard let photoOutput = self.photoOutput else { return }
        sessionQueue.async {
            let photoSettings = AVCapturePhotoSettings()
            
            // Set flash mode if available.
            let isFlashAvailable = self.deviceInput?.device.isFlashAvailable ?? false
            photoSettings.flashMode = isFlashAvailable ? .auto : .off
            
            #if !os(macOS)
            if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
            }
            #endif
            
            photoSettings.photoQualityPrioritization = .balanced
            
            #if !os(macOS)
            // Update photo output connection with current video rotation angle.
            if let connection = photoOutput.connection(with: .video),
               connection.isVideoRotationAngleSupported(self.deviceRotationAngle) {
                connection.videoRotationAngle = self.deviceRotationAngle
            }
            #endif
            
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        if let error = error {
            logger.error("Error capturing photo: \(error.localizedDescription)")
            return
        }
        addToPhotoStream?(photo)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }
        #if os(iOS)
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer).oriented(connection.isVideoMirrored ? .left : .right)
        #elseif os(macOS)
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        #endif
        
        // Yield the preview frame as a CIImage.
        addToPreviewStream?(ciImage)
    }
}

// MARK: - Logger
fileprivate let logger = Logger(subsystem: "com.example.CameraManager", category: "Camera")


