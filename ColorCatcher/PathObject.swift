//
//  PathObject.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 05/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit


struct PathObject {
    let path: UIBezierPath
    let duration: Double
    
    
    init(path: UIBezierPath, duration: Double) {
        self.path = path
        self.duration = duration
    }
}



