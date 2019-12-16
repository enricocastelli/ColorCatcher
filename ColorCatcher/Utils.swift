//
//  Utils.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 04/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

func Logger(_ error: String) {
    print("🎨⚠️ - \(error)")
}

func Logger(_ error: Error) {
    print("🎨⚠️ - \((error as NSError).description)")
}

func Logger(_ event: Event,_ parameters: [String: String]? = nil) {
    let parameterString = parameters == nil ? "" : "\(String(describing: parameters))"
    print("🎨🎯 - \((event.rawValue, parameterString))")
}

func prettyPrint(data: Data?) {
    print(String(data: data!, encoding: String.Encoding.utf8) ?? "No Data")
}

func yesOrNo(_ options: UInt32) -> Bool {
    return arc4random_uniform(options) == 0
}

func isUITestRunning() -> Bool {
    let arguments = ProcessInfo.processInfo.arguments
    return arguments.contains("NoAnimations")
}

func random(_ min: Int, _ max: Int) -> CGFloat {
    return CGFloat(arc4random_uniform(UInt32(max - min))) + CGFloat(min)
}

func isSimulator() -> Bool {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier == "i386" || identifier == "x86_64"
}


enum Device : String {
    
    case SE
    case Seven
    case Plus
    case X
    case XPlus
    case XR
    case Simulator
    case iPad
    case Unknown
    
    static func isSE() -> Bool {
        return UIDevice.current.getDevice() == Device.SE
    }
    
    static func isX() -> Bool {
        return UIDevice.current.getDevice() == Device.X
    }
    
}

extension UIDevice {
    
    func getDevice() -> Device {
        switch UIScreen.main.bounds.height {
        case 812:
            return Device.X
        case 736:
            return Device.Plus
        case 667:
            return Device.Seven
        case 568:
            return Device.SE
        case 896:
            return Device.X
        default:
            Logger("Device Size not recognized!")
            return Device.Seven
        }
    }
    
}
