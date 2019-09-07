//
//  FlashButton.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 07/03/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit
import AVFoundation

protocol FlashProvider {
    func openFlash(_ completion: @escaping(Bool) -> ())
}

extension FlashProvider {
    
    func openFlash(_ completion: @escaping(Bool) -> ()) {
        guard let device = getDevice() else { return }
        if device.torchMode == AVCaptureDevice.TorchMode.on {
            device.torchMode = AVCaptureDevice.TorchMode.off
            completion(false)
            return
        }
        do {
            try device.setTorchModeOn(level: 0.8)
            completion(true)
        } catch {
            Logger(error.localizedDescription)
        }
        device.unlockForConfiguration()
    }
    
    private func getDevice() -> AVCaptureDevice? {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch
            else { return nil }
        do {
            try device.lockForConfiguration()
        } catch {
            Logger("Error opening flash")
        }
        return device
    }
}
