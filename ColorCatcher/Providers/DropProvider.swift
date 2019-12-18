//
//  DropProvider.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 04/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

protocol DropProvider {}

extension DropProvider {
    
    func addDropSet(_ amount: Int, color: UIColor? = nil, masterLayer: CALayer) -> [DropLayer] {
        // creating n small drops with different alpha
        var drops = [DropLayer]()
        for _ in 0...amount {
            let layer = DropLayer(color ?? UIColor.generatePopupRandom())
            drops.append(layer)
            masterLayer.addSublayer(layer)
        }
        return drops
    }
    
    func addStroke(_ color: UIColor, masterLayer: CALayer) -> StrokeLayer {
        let stroke = StrokeLayer(color)
        masterLayer.addSublayer(stroke)
        return stroke
    }
}
