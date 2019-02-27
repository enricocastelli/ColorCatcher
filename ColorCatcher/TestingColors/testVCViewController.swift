//
//  testVCViewController.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 25/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class testVCViewController: UIViewController {

    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var stack3: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    @IBAction func tapped(_ sender: UIButton) {
        update()
    }
    
    var tolerance: CGFloat = 0.07

    func update() {
        let color = UIColor.generateRandom()
        (stack2.subviews[1]).backgroundColor = color
        (stack2.subviews[0]).backgroundColor = UIColor.init(
            red: color.redValue - tolerance,
            green: color.greenValue - tolerance,
            blue: color.blueValue - tolerance,
            alpha: 1)
        (stack2.subviews[2]).backgroundColor = UIColor.init(
            red: color.redValue + tolerance,
            green: color.greenValue + tolerance,
            blue: color.blueValue + tolerance,
            alpha: 1)
        
        (stack1.subviews[0]).backgroundColor = UIColor.init(
            red: color.redValue - tolerance,
            green: color.greenValue + tolerance,
            blue: color.blueValue + tolerance,
            alpha: 1)
        (stack1.subviews[1]).backgroundColor = UIColor.init(
            red: color.redValue - tolerance,
            green: color.greenValue + tolerance,
            blue: color.blueValue - tolerance,
            alpha: 1)
        (stack1.subviews[2]).backgroundColor = UIColor.init(
            red: color.redValue - tolerance,
            green: color.greenValue - tolerance,
            blue: color.blueValue + tolerance,
            alpha: 1)
        
        (stack3.subviews[0]).backgroundColor = UIColor.init(
            red: color.redValue + tolerance,
            green: color.greenValue - tolerance,
            blue: color.blueValue - tolerance,
            alpha: 1)
        (stack3.subviews[1]).backgroundColor = UIColor.init(
            red: color.redValue + tolerance,
            green: color.greenValue + tolerance,
            blue: color.blueValue - tolerance,
            alpha: 1)
        (stack3.subviews[2]).backgroundColor = UIColor.init(
            red: color.redValue + tolerance,
            green: color.greenValue - tolerance,
            blue: color.blueValue + tolerance,
            alpha: 1)
    }
    
    func update1() {
        let color = UIColor.generateRandom()
        (stack2.subviews[1]).backgroundColor = color
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        if color.getHue(&h, saturation: &s, brightness: &b, alpha: nil) {
            (stack2.subviews[0]).backgroundColor = UIColor(
                hue: h - 0.03,
                saturation: s - 0.03,
                brightness: b - 0.03,
                alpha: 1)
            (stack2.subviews[2]).backgroundColor = UIColor(
                hue: h + 0.03,
                saturation: s + 0.03,
                brightness: b + 0.03,
                alpha: 1)
            
            (stack1.subviews[0]).backgroundColor = UIColor(
                hue: h - 0.03,
                saturation: s + 0.03,
                brightness: b + 0.03,
                alpha: 1)
            (stack1.subviews[1]).backgroundColor = UIColor(
                hue: h - 0.03,
                saturation: s + 0.03,
                brightness: b - 0.03,
                alpha: 1)
            (stack1.subviews[2]).backgroundColor = UIColor(
                hue: h - 0.03,
                saturation: s - 0.03,
                brightness: b + 0.03,
                alpha: 1)
            
            (stack3.subviews[0]).backgroundColor = UIColor(
                hue: h + 0.03,
                saturation: s - 0.03,
                brightness: b - 0.03,
                alpha: 1)
            (stack3.subviews[1]).backgroundColor = UIColor(
                hue: h + 0.03,
                saturation: s + 0.03,
                brightness: b - 0.03,
                alpha: 1)
            (stack3.subviews[2]).backgroundColor = UIColor(
                hue: h + 0.03,
                saturation: s - 0.03,
                brightness: b + 0.03,
                alpha: 1)
        }

        
    }

}
