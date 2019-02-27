//
//  ColorManager.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 26/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

protocol ColorRecognitionDelegate: class {
    func didRecognisedColor()
    func didUpdateProximity(_ proximity: Float)
}

class ColorManager: NSObject {
    
    static var goalColor = UIColor.generateRandom()
    static var userColor = UIColor.white
    static var tolerance: CGFloat = 0.07
    
    weak static var delegate: ColorRecognitionDelegate?
    
    // check color based on r/g/b values
    static func checkColor(_ userColor: UIColor) {
        ColorManager.userColor = userColor
        delegate?.didUpdateProximity(getColorProximity())
        if abs(userColor.redValue - goalColor.redValue) < tolerance &&
            abs(userColor.greenValue - goalColor.greenValue) < tolerance &&
            abs(userColor.blueValue - goalColor.blueValue) < tolerance {
            updateColor()
            CaptureManager.shared.stopSession()
            delegate?.didRecognisedColor()
            CaptureManager.shared.startSession()
        }
    }
    
    static func updateColor() {
         goalColor = UIColor.generateRandom()
    }
    
    static func getColorProximity() -> Float {
        let red = abs(userColor.redValue - goalColor.redValue)
        let green = abs(userColor.greenValue - goalColor.greenValue)
        let blue = abs(userColor.blueValue - goalColor.blueValue)
        var tot = (1 - (tolerance*3)) - (red + green + blue)
        if tot < 0 { tot = 0 }
        return Float(tot)
    }
    
    // check color based on hue
//    static func checkColor2(_ userColor: UIColor?) {
//        guard let userColor = userColor else { return }
//        guard let userHue = userColor.getHue(), let goalHue = goalColor.getHue() else { return }
//        updateString(user: userHue, goal: goalHue)
//        if abs(userHue.hue - goalHue.hue) < tolerance &&
//            abs(userHue.brightness - goalHue.brightness) < tolerance &&
//            abs(userHue.saturation - goalHue.saturation) < tolerance {
//            animateSuccess()
//        }
//    }
}
