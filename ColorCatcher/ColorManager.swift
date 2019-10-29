//
//  ColorManager.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 26/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//


import UIKit


protocol ColorRecognitionDelegate: class {
    func didRecognisedColor()
    func didUpdateProximity(_ proximity: Double)
    func didFinishColors()
}

class ColorManager: NSObject, StoreProvider, ColorCalculator {
    
    static let shared = ColorManager()
    var goalColor = UIColor.generateRandom()
    var userColor = UIColor.white
    var tolerance: Double = 90
    
    var colors = [ColorModel]()
    var currentColor: ColorModel?
    
    weak  var delegate: ColorRecognitionDelegate?
    
    func checkColor(_ userColor: UIColor) {
        ColorManager.shared.userColor = userColor
        let proximity = ColorManager.shared.getColorProximity(userColor, goalColor)
        delegate?.didUpdateProximity(proximity)
        if proximity > tolerance {
            delegate?.didRecognisedColor()
        }
    }
    
    func updateColor() {
        goalColor = UIColor.generateRandom()
    }
    
    func updateColorWithLevel() {
        let level = ColorManager().retrieveLevel()
        guard level < colors.count else {
            delegate?.didFinishColors()
            return
        }
        currentColor = colors[level]
        goalColor = UIColor(hex: currentColor!.hex)
    }
    
    
    func fetchColors(success: @escaping () -> (), failure: @escaping () -> ()) {
        Service.shared.get(success: { (object) in
            ColorManager.shared.colors = object.colors
            success()
        }) { (error) in
            failure()
        }
    }
}

