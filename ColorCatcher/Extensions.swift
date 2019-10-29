//
//  Extensions.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 29/10/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit


extension CALayer {
    
    func fadeOut(_ duration: Double) {
        let opAnim = CABasicAnimation(keyPath: "opacity")
        opAnim.duration = 0.3
        opAnim.fromValue = 1
        opAnim.toValue = 0
        opAnim.isRemovedOnCompletion = false
        add(opAnim, forKey: "opacity")
        opacity = 0
    }
    
    func fadeOutWithDelay(_ duration: Double, delay: TimeInterval) {
        let opAnim = CABasicAnimation(keyPath: "opacity")
        opAnim.duration = duration
        opAnim.fromValue = 1
        opAnim.beginTime = CACurrentMediaTime() + delay
        opAnim.toValue = 0
        opAnim.isRemovedOnCompletion = false
        add(opAnim, forKey: "opacity")
        opacity = 0
    }
    
}
