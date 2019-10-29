//
//  DropLayer.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 29/10/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class DropLayer: CAShapeLayer {
    
    let isSlow: Bool = arc4random_uniform(20) == 5
    let color: UIColor
    
    
    init(_ color: UIColor) {
        self.color = color
        super.init()
        let randomWidth: CGFloat = getRandomWidth()
        let randomX: CGFloat = getRandomX()
        let randomY: CGFloat = getRandomY()
        let noneRect = CGRect(x: randomX + (randomWidth/2), y: randomY + (randomWidth/2), width: 0, height: 0)
        let initialBezier = UIBezierPath(ovalIn: noneRect)
        let rect = CGRect(x: randomX, y: randomY, width: randomWidth, height: randomWidth)
        let finalBezier = UIBezierPath(ovalIn: rect)
        self.path = initialBezier.cgPath
        setColor()
        animateDrop(initialPath: initialBezier, finalPath: finalBezier)
    }
    
    override init(layer: Any) {
        self.color = UIColor.generateRandom()
        super.init(layer: layer)
    }
    
    func setColor() {
        let randomAlpha: CGFloat = isSlow ? 1 : (CGFloat(arc4random_uniform(10)) + 2)/10
        fillColor = color.variateColor().withAlphaComponent(randomAlpha).cgColor
    }
    
    func getRandomWidth() -> CGFloat {
        let dividend = CGFloat(arc4random_uniform(UInt32(40)) + 3)
        return UIScreen.main.bounds.width/dividend
    }
    
    func getRandomX() -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width)))
    }
    
    func getRandomY() -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.height)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animateDrop(initialPath: UIBezierPath, finalPath: UIBezierPath) {
        let duration: Double =  isSlow ? Double(arc4random_uniform(40) + 30)/10 : Double(arc4random_uniform(3) + 2)/10
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.fromValue = initialPath.cgPath
        animation.toValue = finalPath.cgPath
        animation.timingFunction = isSlow ? CAMediaTimingFunction(name: .easeOut) : CAMediaTimingFunction(name: .easeInEaseOut)
        self.add(animation, forKey: "updatePath")
        self.path = finalPath.cgPath
    }
    
    func fade() {
        let duration: Double =  Double(arc4random_uniform(3) + 2)/10
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.fromValue = path
        let noneRect = CGRect(x: UIScreen.main.bounds.width/2, y: 0, width: 0, height: 0)
        let noneBezier = UIBezierPath(ovalIn: noneRect)
        animation.toValue = noneBezier.cgPath
        animation.timingFunction = isSlow ? CAMediaTimingFunction(name: .easeOut) : CAMediaTimingFunction(name: .easeInEaseOut)
        self.add(animation, forKey: "updatePath")
        self.path = noneBezier.cgPath
    }
    
}
