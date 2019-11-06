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
