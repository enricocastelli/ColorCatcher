//
//  EyeProximityTestVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 14/08/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class EyeProximityTestVC: UIViewController, ColorCalculator {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var mainColorView: UIView!
    @IBOutlet weak var othersView: UIView!

    var views = [UIView]()
    var xPos: CGFloat = 0
    var yPos: CGFloat = 36
    var level = 0.8
    var goalColor = UIColor.white
    var foundCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        mainColorView.layer.borderColor = UIColor.white.cgColor
        mainColorView.layer.borderWidth = 4
    }
    
    @IBAction func tapped(_ sender: UIButton) {
        update()
    }
    
    func update() {
        reset()
        goalColor = UIColor.generateRandom()
        mainColorView.backgroundColor = goalColor
        red()
        green()
        blue()
        Logger("Found: \(foundCount)")
    }
    
    func red() {
        for index in 0...255 {
            let color = UIColor.init(red: goalColor.redValue + CGFloat(index)/255, green: goalColor.greenValue, blue: goalColor.blueValue, alpha: 1)
            let proximity = getColorProximity(color, goalColor)
            if proximity > level {
                createView(color)
            }
        }
    }
    
    func green() {
        for index in 0...255 {
            let color = UIColor.init(red: goalColor.redValue, green: goalColor.greenValue  + CGFloat(index)/255, blue: goalColor.blueValue, alpha: 1)
            let proximity = getColorProximity(color, goalColor)
            if proximity > level {
                createView(color)
            }
        }
    }
    
    func blue() {
        for index in 0...255 {
            let color = UIColor.init(red: goalColor.redValue + CGFloat(index)/255, green: goalColor.greenValue, blue: goalColor.blueValue + CGFloat(index), alpha: 1)
            let proximity = getColorProximity(color, goalColor)
            if proximity > level {
                createView(color)
            }
        }
    }
    
    func createView(_ color: UIColor) {
        foundCount += 1
        let colorView = UIView(frame: CGRect(x: getX(), y: yPos, width: 20, height: 20))
        colorView.backgroundColor = color
        views.append(colorView)
        othersView.addSubview(colorView)
    }
    
    func getX() -> CGFloat {
        guard xPos < UIScreen.main.bounds.width else {
            yPos += 20
            xPos = 0
            return xPos
        }
        defer {
            xPos += 20
        }
        return xPos
    }
    
    func reset() {
        for v in views {
            v.removeFromSuperview()
        }
        views.removeAll()
        yPos = 36
        xPos = 0
        foundCount = 0
    }

    
}
