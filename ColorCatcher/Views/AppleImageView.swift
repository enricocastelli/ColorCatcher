//
//  AppleImageView.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 03/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

enum Apple: String {
    case Yellow, Green, Red
}


class AppleImageView: UIImageView {
    
    let duration: Double
    let apple: Apple
    
    init(_ frame: CGRect, _ apple: Apple, _ duration: Double) {
        self.duration = duration
        self.apple = apple
        super.init(frame: frame)
        self.image = UIImage(named: "\(apple.rawValue.lowercased())Apple")
        setup()
    }
    
    private func setup() {
        alpha = 0
        animate()
        let _ = Timer.scheduledTimer(withTimeInterval: 8.5, repeats: false) { (_) in
            self.animateAway()
        }
    }
    
    private func animate() {
        UIView.animate(withDuration: duration) {
            self.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2/0.9)
            self.alpha = 1
        }
    }
    
    private func animateAway() {
        UIView.animate(withDuration: duration, animations: {
            self.center =  self.getAwayPosition()
            self.alpha = 1
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    private func getAwayPosition() -> CGPoint {
        switch apple {
        case .Yellow: return CGPoint(x: UIScreen.main.bounds.width, y: -frame.width)
        case .Red: return CGPoint(x: -frame.width, y: -frame.width)
        case .Green: return CGPoint(x: UIScreen.main.bounds.width/2, y: -frame.width)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
