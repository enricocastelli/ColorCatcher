//
//  TimerLabel.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 03/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class TimerLabel: UILabel  {
    
    var count = 0
    var timer: Timer!
    var texts = [String]()
    
    
    func start(_ texts: [String]) {
        self.texts = texts
        nextLabel()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (_) in
            self.nextLabel()
        })
    }
    
    func nextLabel() {
        guard count < texts.count else {
            timer.invalidate()
            return
        }
        changeText(texts[count])
        count += 1
    }
    
    func changeText(_ newText: String) {
        let anim = CATransition()
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        anim.type = CATransitionType.push
        anim.duration = 0.55
        if self.text != newText {
            self.layer.add(anim, forKey: "change")
            self.text = newText
        }
    }
}

