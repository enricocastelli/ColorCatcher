//
//  ButterflyView.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 06/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class ButterflyView: Animator {
    
    override func setup() {
        tintColor = UIColor.generateCCRandom()
    }
    
    func animatePos(_ pathOb: PathObject, remove: Bool? = nil, shouldRotate: Bool? = nil) {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = pathOb.path.cgPath
        anim.duration = pathOb.duration
        anim.rotationMode = (shouldRotate == false) ? nil : .rotateAuto
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        anim.fillMode = CAMediaTimingFillMode.forwards
        anim.isRemovedOnCompletion = false
        let _ = Animation(animation: anim, object: layer) {
            self.stopAtFirst()
            if remove ?? true {
                self.removeFromSuperview()
            }
        }
    }
}

