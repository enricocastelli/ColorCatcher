//
//  StrokeLayer.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 17/12/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class StrokeLayer: CAShapeLayer {

    let color: UIColor
    var bezierPath = UIBezierPath()
    var lineLayers = [CAShapeLayer]()
    lazy var animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.timingFunction = .init(controlPoints: 0.5, 0.2, 1, 2)
        animation.duration = 0.8
        animation.fromValue = 0
        animation.toValue = 1
        return animation
    }()

    
    init(_ color: UIColor) {
        self.color = color
        super.init()
        createPath()
        addBigLayer()
        addShortLayer()
    }
    
    private func createPath() {
        let startPoint = CGPoint(x: -20, y: 36)
        let finalPoint = CGPoint(x: UIScreen.main.bounds.width + 20, y: 36)
        let control1 = CGPoint(x: 0, y: UIScreen.main.bounds.width/3)
        let control2 = CGPoint(x: 0, y: UIScreen.main.bounds.width/2)
        bezierPath.move(to: startPoint)
        bezierPath.addCurve(to: finalPoint, controlPoint1: control1, controlPoint2: control2)
    }
    
    func addBigLayer() {
        let lineLayer = CAShapeLayer()
        lineLayer.path = bezierPath.cgPath
        lineLayer.strokeColor = color.cgColor
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.masksToBounds = false
        lineLayer.lineWidth = 40
        lineLayer.add(animation, forKey: "drawPath")
        lineLayer.strokeEnd = 1
        self.addSublayer(lineLayer)
        lineLayers.append(lineLayer)
    }
    
    func addShortLayer() {
        let lineLayer = CAShapeLayer()
        lineLayer.path = bezierPath.cgPath
        lineLayer.strokeColor = UIColor.white.cgColor
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.masksToBounds = false
        lineLayer.lineWidth = 4
        lineLayer.add(animation, forKey: "drawPath")
        lineLayer.position.y -= 10
        lineLayer.opacity = 0.4
        lineLayer.strokeEnd = 1
        self.addSublayer(lineLayer)
        lineLayers.append(lineLayer)
    }
    
    func fade() {
        for lineLayer in lineLayers {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.timingFunction = .init(controlPoints: 0.5, 0.2, 1, 2)
            animation.duration = 0.4
            animation.fromValue = 1
            animation.toValue = 0
            animation.isRemovedOnCompletion = false
            lineLayer.add(animation, forKey: "drawPath")
            lineLayer.strokeEnd = 0
            self.addSublayer(lineLayer)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
