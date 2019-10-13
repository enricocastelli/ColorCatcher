//
//  TimerProvider.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 26/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

protocol ColorTimerDelegate: class {
    func timerIsExpired()
    func timerUpdate(_ seconds: Int)
}

class ColorTimer {
    
    static let shared = ColorTimer()
    var seconds = 60
    var timer = Timer()
    weak var delegate: ColorTimerDelegate?
    
    func fire() {
        seconds = 60
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            guard self.seconds >= 1 else {
                timer.invalidate()
                self.delegate?.timerIsExpired()
                self.resetTime()
                return
            }
            self.seconds -= 1
            self.delegate?.timerUpdate(self.seconds)
        }
    }
    
    func applyPenalty() {
        if seconds < 5  {
            seconds = 0
        } else {
            seconds -= 5
        }
        delegate?.timerUpdate(seconds)
    }
    
    func invalidate() {
        timer.invalidate()
    }

    private func resetTime() {
        seconds = 60
    }
    
}
