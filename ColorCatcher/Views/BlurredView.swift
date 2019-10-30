//
//  BlurredView.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 30/10/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class BlurredView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBlur()
    }
    
    func addBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBlur()
    }
}
