//
//  WelcomeAnimation.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 07/09/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit



class WelcomeAnimationView: UIView {
    
    var animationColor = ChameleonColor.random()
    let sWidth = UIScreen.main.bounds.width
    let sHeight = UIScreen.main.bounds.height

    var chameleon: ChameleonView!

    func startWelcomeAnimation() {
        animationColor = ChameleonColor.random()
        addChameleon(true)
        animateButterflies()
        animateSecondButterfly()
    }
    
    func removeAllAnimations() {
        for sub in subviews where sub.isKind(of: Animator.self) {
            (sub as? Animator)?.stop()
            sub.removeFromSuperview()
        }
    }
    
    func addChameleon(_ animated: Bool) {
        chameleon = ChameleonView()
        chameleon.center.y = frame.height/2
        self.addSubview(chameleon)
        chameleon.center.x = (self.sWidth/2) - 5
        guard animated else {
            chameleon.goToStatic()
            chameleon.center.x = (self.sWidth/2)
            return
        }
        chameleon.start()
        UIView.animate(withDuration: 5, delay: 0, options: [], animations: {
            self.chameleon.center.x = (self.sWidth/2)
        }, completion: { (_) in
            guard !self.chameleon.wentBackground else {
                self.chameleon.goToStatic()
                return }
            self.chameleon.stopAtFirst {
                self.chameleon.goToStatic()
                self.chameleon.changeColor(self.animationColor, 1)
            }
        })
    }
    
    func animateButterflies() {
        for _ in 0...13 {
            animateBut()
        }
    }
    
    func animateBut() {
        let random = CGFloat(arc4random_uniform(13) + 14)
        let but = ButterflyView(CGRect(x: -20, y: 0, width: random, height: random), imageName: "but", count: 6, frameTime: Double(0.02 + random/1000))
        self.addSubview(but)
        but.start()
        but.animatePos(createPathObject())
    }
    
    func animateSecondButterfly() {
        let width = sWidth/15
        let butY = chameleon.frame.minY + (width/2)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -width, y: butY))
        path.addLine(to: CGPoint(x: (sWidth/2) + width/2, y: butY))
        let but = ButterflyView(CGRect(x: 0, y: 0, width: width, height: width), imageName: "but", count: 6, frameTime: Double(0.04 + width/1000))
        self.addSubview(but)
        but.tintColor = animationColor.color()
        but.start()
        let pathObject = PathObject(path: path, duration: 7)
        but.animatePos(pathObject, remove: false)
        let _ = Timer.scheduledTimer(withTimeInterval: 9, repeats: false) { (_) in
            but.start()
            but.animatePos(self.createFinalPathObject(width), shouldRotate: false)
            UIView.animate(withDuration: 4, animations: {
                but.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
        }
    }
    
    func createPathObject() -> PathObject {
        let path = UIBezierPath()
        var randomDuration = Double(random(40, 100))/10
        
        let randomFinalY = chameleon.frame.minY + random(-80, 80)
        let randomStartX = random(-30, -10)
        let randomStartY = chameleon.frame.minY + random(-20, 20)
        let randomCPX = random(50, 150)
        let randomCPY = random(-200, 10)
        let randomCP2X = random(120, 330)
        let randomCP2Y = random(-100, 160)
        
        path.move(to: CGPoint(x: randomStartX, y: randomStartY))
        if yesOrNo(10) {
            let randomCP3X = random(70,130)
            let randomCP3Y = random(0,120)
            let randomCP4X = random(200,320)
            let randomCP4Y = random(-40,120)
            path.addCurve(to: CGPoint(x: sWidth/2, y: -frame.height/2), controlPoint1: CGPoint(x: randomCP3X, y: randomCP3Y), controlPoint2: CGPoint(x: randomCP4X, y: randomCP4Y))
            randomDuration += 2
        }
        path.addCurve(to: CGPoint(x: frame.width + 30, y: randomFinalY), controlPoint1: CGPoint(x: randomCPX, y: randomCPY), controlPoint2: CGPoint(x: randomCP2X, y: randomCP2Y))
        return PathObject(path: path, duration: randomDuration)
    }
    
    func createFinalPathObject(_ width: CGFloat) -> PathObject {
        let path = UIBezierPath()
        let startPoint = CGPoint(x: (sWidth/2) + width/2, y: chameleon.frame.minY + (width/2))
        let randomDuration = 5.0
        let randomCPX =  sWidth/1.1
        let randomCPY = frame.height/(-0.54)
        let randomCP2X = sWidth/2
        let randomCP2Y: CGFloat = frame.height/(-0.2)
        path.move(to: startPoint)
        path.addCurve(to: CGPoint(x: (sWidth/2), y: frame.height/(-0.36)), controlPoint1: CGPoint(x: randomCPX, y: randomCPY), controlPoint2: CGPoint(x: randomCP2X, y: randomCP2Y))
        return PathObject(path: path, duration: randomDuration)
    }
}

struct PathObject {
    let path: UIBezierPath
    let duration: Double
    
    
    init(path: UIBezierPath, duration: Double) {
        self.path = path
        self.duration = duration
    }
}
