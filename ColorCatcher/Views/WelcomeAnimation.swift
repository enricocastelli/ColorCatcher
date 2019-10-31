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

struct PathObject {
    let path: UIBezierPath
    let duration: Double
}

extension WelcomeAnimator where Self: UIViewController {
    
    func startWelcomeAnimation() {
        animatechameleon()
        animateButterflies()
        animateSecondButterfly()
    }
    
    func removeAllAnimations() {
        for sub in view.subviews where sub.isKind(of: Animator.self) {
            (sub as? Animator)?.stop()
            sub.removeFromSuperview()
        }
    }
    
    func animatechameleon() {
        let chameleon = ChameleonView()
        self.view.addSubview(chameleon)
        chameleon.start()
        UIView.animate(withDuration: 9.8, delay: 0, options: [], animations: {
            chameleon.frame.origin.x = self.view.center.x - chameleon.frame.width/2
        }, completion: { (_) in
            chameleon.stopAtFirst {
                chameleon.goToStatic()
                chameleon.changeColor(0.8)
            }
        })
        let _ = Timer.scheduledTimer(withTimeInterval: 8, repeats: false) { (_) in
            chameleon.stop()
            chameleon.start(0.065)
        }

    }
    
    func animateButterflies() {
        for _ in 0...13 {
            animateBut()
        }
    }
    
    func animateBut() {
        let random = CGFloat(arc4random_uniform(13) + 14)
        let but = ButterflyView(CGRect(x: -20, y: getButterfliesY(), width: random, height: random), imageName: "but", count: 6, frameTime: Double(0.02 + random/1000))
        self.view.addSubview(but)
        but.tintColor = UIColor.generateCCRandom()
        but.start()
        but.animatePos(createPathObject())
    }
    
    func animateSecondButterfly() {
        let random = CGFloat(arc4random_uniform(13) + 18)
        let but = ButterflyView(CGRect(x: self.view.center.x, y: getButterfliesY(), width: random, height: random), imageName: "but", count: 6, frameTime: Double(0.04 + random/1000))
        but.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.view.addSubview(but)
        but.tintColor = UIColor.generateCCRandom()
        but.start()
        UIView.animate(withDuration: 1.4, delay: 5, options: [], animations: {
            but.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        let _ = Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { (_) in
            but.stopAtFirst(completion: {})
        }
        let _ = Timer.scheduledTimer(withTimeInterval: 9, repeats: false) { (_) in
            but.start()
            but.animatePos(self.createFinalPathObject(random))
            UIView.animate(withDuration: 4, animations: {
                but.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })

        }
    }
    
    func getButterfliesY() -> CGFloat {
        return UIScreen.main.bounds.height/4
    }
    
    func createPathObject() -> PathObject {
        let path = UIBezierPath()
        var randomDuration = (Double(arc4random_uniform(40) + 45))/10
        let randomX = CGFloat(arc4random_uniform(10)) - 40
        let randomY = CGFloat(arc4random_uniform(60) + UInt32(getButterfliesY()))
        let randomCPX = CGFloat(arc4random_uniform(100) + 50)
        let randomCPY = CGFloat(arc4random_uniform(20)) - 20
        let randomCP2X = CGFloat(arc4random_uniform(150) + 50)
        let randomCP2Y = CGFloat(arc4random_uniform(200)) + 100
        
        path.move(to: CGPoint(x: randomX, y: randomY))
        if yesOrNo(4) {
            let randomCP3X = CGFloat(arc4random_uniform(10) + 50)
            let randomCP3Y = CGFloat(arc4random_uniform(30)) + 20
            let randomCP4X = CGFloat(arc4random_uniform(200) + 200)
            let randomCP4Y = CGFloat(arc4random_uniform(130)) - 200
            path.addCurve(to: CGPoint(x: self.view.frame.width, y: 0), controlPoint1: CGPoint(x: randomCP3X, y: randomCP3Y), controlPoint2: CGPoint(x: randomCP4X, y: randomCP4Y))
            randomDuration += 1
        }
        path.addCurve(to: CGPoint(x: self.view.frame.width + 20, y: 80), controlPoint1: CGPoint(x: randomCPX, y: randomCPY), controlPoint2: CGPoint(x: randomCP2X, y: randomCP2Y))
        return PathObject(path: path, duration: randomDuration)
    }
    
    func createFinalPathObject(_ width: CGFloat) -> PathObject {
        let path = UIBezierPath()
        let randomDuration = 5.0
        
        let randomCPX = self.view.center.x + 60
        let randomCPY = getButterfliesY()
        let randomCP2X = self.view.center.x + 100
        let randomCP2Y: CGFloat = -100.0
        path.move(to: CGPoint(x: self.view.center.x + width/2, y: getButterfliesY() + width/2))
        path.addCurve(to: CGPoint(x: self.view.frame.width/2, y: -50), controlPoint1: CGPoint(x: randomCPX, y: randomCPY), controlPoint2: CGPoint(x: randomCP2X, y: randomCP2Y))
        return PathObject(path: path, duration: randomDuration)
    }
}

class ButterflyView: Animator {
    
    func animatePos(_ pathOb: PathObject) {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = pathOb.path.cgPath
        anim.duration = pathOb.duration
        anim.rotationMode = CAAnimationRotationMode.rotateAuto
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        anim.fillMode = CAMediaTimingFillMode.forwards
        anim.isRemovedOnCompletion = false
        let _ = Animation(animation: anim, object: layer) {
            self.stop()
            self.removeFromSuperview()
        }
    }
}

