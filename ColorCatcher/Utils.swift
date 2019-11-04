//
//  Utils.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 04/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import Foundation

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

