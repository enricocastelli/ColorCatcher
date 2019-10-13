//
//  WelcomeAnimation.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 07/09/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit


protocol WelcomeAnimator {
    
    func startWelcomeAnimation()
    
}

extension WelcomeAnimator where Self: UIViewController {
    
    func startWelcomeAnimation() {
        animateFox()
        animateButterflies()
        createEarthPath()
        let _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
            self.animateSecondButterflies()
        }
    }
    
    func animateFox() {
        let foxHeight = getFoxHeight()
        let fox = Animator(CGRect(x: -foxHeight, y: getFoxY(), width: foxHeight, height: foxHeight), imageName: "fox", count: 6, frameTime: 0.09)
        self.view.addSubview(fox)
        fox.start()
        UIView.animate(withDuration: 9, delay: 1, options: [], animations: {
            fox.frame.origin.x = self.view.frame.width + foxHeight
        }, completion: { (_) in
            fox.removeFromSuperview()
        })
    }
    
    func getFoxHeight() -> CGFloat {
        return UIScreen.main.bounds.height/3
    }
    
    func getFoxY() -> CGFloat {
        return UIScreen.main.bounds.height/33.3
    }
    
    func animateButterflies() {
        for _ in 0...10 {
            animateBut()
        }
    }
    
    func animateBut() {
        let random = CGFloat(arc4random_uniform(13) + 14)
        let but = Animator(CGRect(x: -20, y: getButterfliesY(), width: random, height: random), imageName: "but", count: 6, frameTime: Double(0.02 + random/1000))
        self.view.addSubview(but)
        but.tintColor = UIColor.generateCCRandom()
        but.start()
        let pathOb = createPathObject()
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = pathOb.path.cgPath
        anim.duration = pathOb.duration
        anim.rotationMode = CAAnimationRotationMode.rotateAuto
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        anim.fillMode = CAMediaTimingFillMode.forwards
        anim.isRemovedOnCompletion = false
        let _ = Animation(animation: anim, object: but.layer) {
            but.removeFromSuperview()
        }
    }
    
    func animateSecondButterflies() {
        let random = CGFloat(arc4random_uniform(13) + 18)
        let but = Animator(CGRect(x: self.view.center.x, y: getButterfliesY(), width: random, height: random), imageName: "but", count: 6, frameTime: Double(0.04 + random/1000))
        self.view.addSubview(but)
        but.tintColor = UIColor.generateCCRandom()
        but.start()
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
            but.stop()
        }
        let _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
            but.start()
        }
        UIView.animate(withDuration: 3, delay: 5, options: [.curveEaseInOut], animations: {
            but.frame.origin.y = -self.getButterfliesY()
            but.frame.origin.x = self.view.center.x + self.getButterfliesY()
        }) { (_) in
            but.removeFromSuperview()
        }
    }
    
    func getButterfliesY() -> CGFloat {
        return UIScreen.main.bounds.height/8
    }
    
    func createPathObject() -> (path: UIBezierPath, duration: Double) {
        let path = UIBezierPath()
        var randomDuration = (Double(arc4random_uniform(40) + 45))/10
        let randomX = CGFloat(arc4random_uniform(10)) - 40
        let randomY = CGFloat(arc4random_uniform(10) + UInt32(getButterfliesY()))
        let randomCPX = CGFloat(arc4random_uniform(40) + 50)
        let randomCPY = CGFloat(arc4random_uniform(10)) - 20
        let randomCP2X = CGFloat(arc4random_uniform(150) + 50)
        let randomCP2Y = CGFloat(arc4random_uniform(100)) + 100
        
        path.move(to: CGPoint(x: randomX, y: randomY))
        if yesOrNo(4) {
            let randomCP3X = CGFloat(arc4random_uniform(20) + 200)
            let randomCP3Y = CGFloat(arc4random_uniform(0)) + 100
            let randomCP4X = CGFloat(arc4random_uniform(100) + 200)
            let randomCP4Y = CGFloat(arc4random_uniform(100)) - 200
            path.addCurve(to: CGPoint(x: self.view.frame.width, y: 0), controlPoint1: CGPoint(x: randomCP3X, y: randomCP3Y), controlPoint2: CGPoint(x: randomCP4X, y: randomCP4Y))
            randomDuration += 1
        }
        path.addCurve(to: CGPoint(x: self.view.frame.width + 20, y: 80), controlPoint1: CGPoint(x: randomCPX, y: randomCPY), controlPoint2: CGPoint(x: randomCP2X, y: randomCP2Y))
        return (path: path, duration: randomDuration)
    }
    
    func createLeftPath() -> UIBezierPath {
        let randomX = self.view.center.x
        let path = UIBezierPath()
        path.move(to: CGPoint(x: randomX, y: getButterfliesY()))
        path.addLine(to: CGPoint(x: randomX, y: -100))
        return path
    }
    
    func createEarthPath() {
        let bezPath = UIBezierPath()
        let offset: CGFloat = 50
        let lineY = getFoxY() + getFoxHeight() - offset
        bezPath.move(to: CGPoint(x: 0, y: lineY))
        bezPath.addLine(to: CGPoint(x: self.view.frame.width + 100, y: lineY))
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.lineCap = CAShapeLayerLineCap.round
        shape.strokeColor = UIColor.darkGray.cgColor
        shape.opacity = 0.8
        shape.path = bezPath.cgPath
        self.view.layer.addSublayer(shape)
        animateLine(shape)
    }
    
    func animateLine(_ layer: CAShapeLayer) {
        let duration: CFTimeInterval = 14
        let beginTime = 2.5
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.fromValue = 0
        end.toValue = 1.0175
        end.beginTime = beginTime
        end.duration = duration * 0.75
        end.timingFunction = CAMediaTimingFunction(controlPoints: 0.3, 0.88, 0.09, 0.99)
        end.fillMode = CAMediaTimingFillMode.forwards

        let begin = CABasicAnimation(keyPath: "strokeStart")
        begin.fromValue = 0
        begin.toValue = 1.0175
        begin.beginTime = beginTime + (duration * 0.10)
        begin.duration = duration
        begin.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 0.99)
        begin.fillMode = CAMediaTimingFillMode.backwards
        

        let group = CAAnimationGroup()
        group.animations = [end, begin]
        group.duration = duration
        
        layer.strokeEnd = 0
        layer.strokeStart = 1
        
        let _ = Animation(animation: group, object: layer) {
            layer.removeFromSuperlayer()
        }
    }
}
