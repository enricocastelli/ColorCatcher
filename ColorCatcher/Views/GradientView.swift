//
//  GradientView.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 14/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var gradient = CAGradientLayer()
    var locations: [NSNumber] = [0, 0.8]
    var colors = [UIColor.white.withAlphaComponent(0.9).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    private func setup() {
        super.awakeFromNib()
        gradient.locations = locations
        gradient.colors = colors
        self.layer.addSublayer(gradient)
    }
    
    override func layoutSubviews() {
        gradient.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
