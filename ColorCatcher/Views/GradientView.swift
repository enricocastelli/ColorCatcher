//
//  GradientView.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 13/03/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var gradient: CAGradientLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard gradient == nil else { return }
        gradient = CAGradientLayer()
        gradient!.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient!.locations = [0.2,1]
        gradient!.frame = self.frame
        self.layer.insertSublayer(gradient!, at: 0)
    }
}
