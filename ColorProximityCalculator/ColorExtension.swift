//
//  ColorExtension.swift
//  ColorProximityCalculator
//
//  Created by Enrico Castelli on 17/01/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

public extension UIColor {
    
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    
}
