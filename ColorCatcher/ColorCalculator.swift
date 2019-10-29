//
//  ColorCalculator.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 07/03/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

// MARK: - Constants
infix operator ^^ : AdditionPrecedence
func ^^ (radix: Double, power: Int) -> Double {
    return Double(pow(Double(radix), Double(power)))
}

func ^^ (radix: CGFloat, power: Int) -> Double {
    return Double(pow(Double(radix), Double(power)))
}

fileprivate let sl = 1.0
fileprivate let kc = 1.0
fileprivate let kh = 1.0
fileprivate let Kl = 1.0
fileprivate let K1 = 0.045
fileprivate let K2 = 0.015

protocol ColorCalculator {
    
    func getColorProximity(_ userColor: UIColor,_ goalColor: UIColor) -> Double
}


extension ColorCalculator {
   
    // color proximity goes from 0 (completely different color) to 100 (same color)
    func getColorProximity(_ userColor: UIColor,_ goalColor: UIColor) -> Double {
        let labA = toLAB(userColor)
        let labB = toLAB(goalColor)
        let deltaL = labA.L - labB.L
        let deltaA = labA.A - labB.A
        let deltaB = labA.B - labB.B
        
        let c1 = sqrt((labA.A^^2) + (labA.B^^2))
        let c2 = sqrt((labB.A^^2) + (labB.B^^2))
        let deltaC = c1 - c2;
        
        var deltaH = (deltaA^^2) + (deltaB^^2) - (deltaC^^2)
        deltaH = deltaH < 0 ? 0 : sqrt(deltaH)
        
        let sc = 1.0 + K1*c1
        let sh = 1.0 + K2*c1
        
        let i = (deltaL/(Kl*sl)^^2) + (deltaC/(kc*sc)^^2) + (deltaH/(kh*sh)^^2)
        var finalResult = i < 0 ? 0 : sqrt(i)
        if finalResult > 100 { finalResult = 100 }
        return 100 - finalResult
    }
    
    func toLAB(_ color: UIColor) -> LABColor {
        let r = RGBColor(r: color.redValue, g: color.greenValue, b: color.blueValue, alpha: 1)
        return r.toLAB()
    }
}

private let LAB_E: CGFloat = 0.008856
private let LAB_16_116: CGFloat = 0.1379310
private let LAB_K_116: CGFloat = 7.787036
private let LAB_X: CGFloat = 0.95047
private let LAB_Y: CGFloat = 1
private let LAB_Z: CGFloat = 1.08883

// MARK: - RGB
public struct RGBColor {
    public let r: CGFloat     // 0..1
    public let g: CGFloat     // 0..1
    public let b: CGFloat     // 0..1
    public let alpha: CGFloat // 0..1
    
    fileprivate func sRGBCompand(_ v: CGFloat) -> CGFloat {
        let absV = abs(v)
        let out = absV > 0.04045 ? pow((absV + 0.055) / 1.055, 2.4) : absV / 12.92
        return v > 0 ? out : -out
    }
    
    public func toXYZ() -> XYZColor {
        let R = sRGBCompand(r)
        let G = sRGBCompand(g)
        let B = sRGBCompand(b)
        let x: CGFloat = (R * 0.4124564) + (G * 0.3575761) + (B * 0.1804375)
        let y: CGFloat = (R * 0.2126729) + (G * 0.7151522) + (B * 0.0721750)
        let z: CGFloat = (R * 0.0193339) + (G * 0.1191920) + (B * 0.9503041)
        return XYZColor(x: x, y: y, z: z, alpha: alpha)
    }
    
    public func toLAB() -> LABColor {
        return toXYZ().toLAB()
    }
    
    public func color() -> UIColor {
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    public func lerp(_ other: RGBColor, t: CGFloat) -> RGBColor {
        return RGBColor(
            r: r + (other.r - r) * t,
            g: g + (other.g - g) * t,
            b: b + (other.b - b) * t,
            alpha: alpha + (other.alpha - alpha) * t
        )
    }
}

public extension UIColor {
    func rgbColor() -> RGBColor? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var alpha: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &alpha) {
            return RGBColor(r: r, g: g, b: b, alpha: alpha)
        } else {
            return nil
        }
    }
}

// MARK: - XYZ
public struct XYZColor {
    public let x: CGFloat     // 0..0.95047
    public let y: CGFloat     // 0..1
    public let z: CGFloat     // 0..1.08883
    public let alpha: CGFloat // 0..1
    
    
    fileprivate func sRGBCompand(_ v: CGFloat) -> CGFloat {
        let absV = abs(v)
        let out = absV > 0.0031308 ? 1.055 * pow(absV, 1 / 2.4) - 0.055 : absV * 12.92
        return v > 0 ? out : -out
    }
    
    public func toRGB() -> RGBColor {
        let r = (x *  3.2404542) + (y * -1.5371385) + (z * -0.4985314)
        let g = (x * -0.9692660) + (y *  1.8760108) + (z *  0.0415560)
        let b = (x *  0.0556434) + (y * -0.2040259) + (z *  1.0572252)
        let R = sRGBCompand(r)
        let G = sRGBCompand(g)
        let B = sRGBCompand(b)
        return RGBColor(r: R, g: G, b: B, alpha: alpha)
    }
    
    fileprivate func labCompand(_ v: CGFloat) -> CGFloat {
        return v > LAB_E ? pow(v, 1.0 / 3.0) : (LAB_K_116 * v) + LAB_16_116
    }
    
    public func toLAB() -> LABColor {
        let fx = labCompand(x / LAB_X)
        let fy = labCompand(y / LAB_Y)
        let fz = labCompand(z / LAB_Z)
        return LABColor(
            L: Double(116 * fy - 16),
            A: Double(500 * (fx - fy)),
            B: Double(200 * (fy - fz)),
            alpha: Double(alpha)
        )
    }
    
    
    public func lerp(_ other: XYZColor, t: CGFloat) -> XYZColor {
        return XYZColor(
            x: x + (other.x - x) * t,
            y: y + (other.y - y) * t,
            z: z + (other.z - z) * t,
            alpha: alpha + (other.alpha - alpha) * t
        )
    }
}

// MARK: - LAB
public struct LABColor {
    public let L: Double     //    0..100
    public let A: Double     // -128..128
    public let B: Double     // -128..128
    public let alpha: Double //    0..1
    
    
    fileprivate func xyzCompand(_ v: CGFloat) -> CGFloat {
        let v3 = v * v * v
        return v3 > LAB_E ? v3 : (v - LAB_16_116) / LAB_K_116
    }
    
}

func convert(_ color: UIColor) -> LABColor {
    let r = RGBColor(r: color.redValue, g: color.greenValue, b: color.blueValue, alpha: 1)
    return r.toLAB()
}
