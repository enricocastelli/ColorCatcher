//
//  ColorCalculator.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 07/03/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

infix operator ^^ : AdditionPrecedence
func ^^ (radix: Double, power: Int) -> Double {
    return Double(pow(Double(radix), Double(power)))
}

protocol ColorCalculator {
    
    func getColorProximity(_ userColor: UIColor,_ goalColor: UIColor) -> Double
}


extension ColorCalculator {
   
    func getColorProximity(_ userColor: UIColor,_ goalColor: UIColor) -> Double {
        let goalC = toXYZ(goalColor)
        let userC = toXYZ(userColor)
        let deltaE = colorProximity(userC, goalC)
        let prox = (40 - deltaE)/40
        guard prox > 0 else { return 0 }
        return prox
    }
    
    private func colorProximity(_ userColor: LABColor,_ goalColor: LABColor) -> Double {
        
        let l1 = Double(userColor.l)
        let a1 = Double(userColor.a)
        let b1 = Double(userColor.b)
        let l2 = Double(goalColor.l)
        let a2 = Double(goalColor.a)
        let b2 = Double(goalColor.b)
        
        let lTot = ((l1 - l2)^^2)
        let aTot = ((a1 - a2)^^2)
        let bTot = ((b1 - b2)^^2)
        
        let deltaE = sqrt(lTot + aTot + bTot)
        return deltaE
    }
    
    private  func toXYZ(_ color: UIColor) -> LABColor {
        let R = sRGBCompand(color.redValue)
        let G = sRGBCompand(color.greenValue)
        let B = sRGBCompand(color.blueValue)
        let x: CGFloat = (R * 0.4124564) + (G * 0.3575761) + (B * 0.1804375)
        let y: CGFloat = (R * 0.2126729) + (G * 0.7151522) + (B * 0.0721750)
        let z: CGFloat = (R * 0.0193339) + (G * 0.1191920) + (B * 0.9503041)
        
        let fx = labCompand(x / LAB_X)
        let fy = labCompand(y / LAB_Y)
        let fz = labCompand(z / LAB_Z)
        return LABColor(
            l: 116 * fy - 16,
            a: 500 * (fx - fy),
            b: 200 * (fy - fz),
            alpha: 1
        )
    }
    
    private func sRGBCompand(_ v: CGFloat) -> CGFloat {
        let absV = abs(v)
        let out = absV > 0.0031308 ? 1.055 * pow(absV, 1 / 2.4) - 0.055 : absV * 12.92
        return v > 0 ? out : -out
    }
    
    private func labCompand(_ v: CGFloat) -> CGFloat {
        return v > LAB_E ? pow(v, 1.0 / 3.0) : (LAB_K_116 * v) + LAB_16_116
    }
}

private struct LABColor {
    public let l: CGFloat
    public let a: CGFloat
    public let b: CGFloat
    public let alpha: CGFloat
    
}

fileprivate let LAB_E: CGFloat = 0.008856
fileprivate let LAB_16_116: CGFloat = 0.1379310
fileprivate let LAB_K_116: CGFloat = 7.787036
fileprivate let LAB_X: CGFloat = 0.95047
fileprivate let LAB_Y: CGFloat = 1
fileprivate let LAB_Z: CGFloat = 1.08883


// OLD DIFFERENT ALGORITHMS

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

//    static func getColorProximity() -> Float {
//        let red = abs(userColor.redValue - goalColor.redValue)
//        let green = abs(userColor.greenValue - goalColor.greenValue)
//        let blue = abs(userColor.blueValue - goalColor.blueValue)
//        var tot = (1 - (tolerance*3)) - (red + green + blue)
//        if tot < 0 { tot = 0 }
//        return Float(tot)
//    }
