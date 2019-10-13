//
//  CameraHanlder.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 22/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit
import AVFoundation

protocol CaptureManagerDelegate: class {
    func processCapturedImage(image: UIImage)
    func failedInitializingSession()
}

class CaptureManager: NSObject {
    
    internal static let shared = CaptureManager()
    weak var delegate: CaptureManagerDelegate?
    var session: AVCaptureSession
    
    override init() {
        session = AVCaptureSession()

        super.init()
        
        do {
            let device = try getDevice()
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
        } catch {
            Logger("Error in input AV")
        }
        
        //setup output
        let output = AVCaptureVideoDataOutput()
        
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: kCVPixelFormatType_32BGRA]
        output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        session.addOutput(output)
    }
    
    func zoom(_ velocity: CGFloat) {
        do {
            let device = try getDevice()
            let maxZoomFactor = device.activeFormat.videoMaxZoomFactor
            let pinchVelocityDividerFactor: CGFloat = 5.0
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            
            let desiredZoomFactor = device.videoZoomFactor + atan2(velocity, pinchVelocityDividerFactor)
            device.videoZoomFactor = max(1.0, min(desiredZoomFactor, maxZoomFactor))
        } catch {
            Logger(error)
        }
    }
    
    private func resetZoom() {
        do {
            let device = try getDevice()
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            device.videoZoomFactor = 1
        } catch {
            Logger(error)
        }
    }
    
    
    func startSession() {
//        // TEST simulator
//        guard !session.inputs.isEmpty else {
//            delegate?.failedInitializingSession()
//            return
//        }
        session.startRunning()
    }
    
    func stopSession() {
        resetZoom()
        session.stopRunning()
    }
    
    func getImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) ->UIImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        guard let cgImage = context.makeImage() else {
            return nil
        }
        let image = UIImage(cgImage: cgImage, scale: 1, orientation:.right)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        return image
    }
    
    func getDevice() throws -> AVCaptureDevice {
        guard let device =  AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw NSError(domain: "", code: 0, userInfo: nil)}
        return device
    }
}

extension CaptureManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let outputImage = getImageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
            return
        }
        delegate?.processCapturedImage(image: outputImage)
    }
}
