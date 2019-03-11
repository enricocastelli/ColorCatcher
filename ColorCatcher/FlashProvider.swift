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
    func openFlash()
}

extension FlashProvider {
    
    func openFlash() {
        guard let device = getDevice() else { return }
        if device.torchMode == AVCaptureDevice.TorchMode.on {
            device.torchMode = AVCaptureDevice.TorchMode.off
            return
        }
        do {
            try device.setTorchModeOn(level: 0.8)
        } catch {
            print(error)
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
