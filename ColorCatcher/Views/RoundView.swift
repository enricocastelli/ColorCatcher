//
//  RoundView.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 04/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class RoundView: UIView {
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.height/2
    }
}
