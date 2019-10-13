//
//  testVCViewController.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 25/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class testVCViewController: UIViewController, ColorCalculator {

    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var stack3: UIStackView!
    lazy var allViews: [UIView] = {
        return stack1.subviews + stack2.subviews + stack3.subviews
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        (stack2.subviews[1]).layer.borderColor = UIColor.black.cgColor
        (stack2.subviews[1]).layer.borderWidth = 1
    }
    
    @IBAction func tapped(_ sender: UIButton) {
        update()
    }
    
    var tolerance: CGFloat = 0.07
    var level = 0.7
    var goalColor = UIColor.white

    func update() {
        goalColor = UIColor.generateRandom()
        let color = goalColor
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
        calculate()
    }
    
    func calculate() {
        for view in allViews {
            calculateProximity(view)
        }
    }
    
    func calculateProximity(_ view: UIView) {
        let prox = getColorProximity(view.backgroundColor ?? UIColor.white, goalColor)
        if Double(level) < prox {
            setColorProx(view)
        } else {
            resetSquare(view)
        }
    }
    
    func setColorProx(_ view: UIView) {
        guard view != (stack2.subviews[1]) else { return }
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 3
    }
    
    func resetSquare(_ view: UIView) {
        guard view != (stack2.subviews[1]) else { return }
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.clear.cgColor
    }

}
