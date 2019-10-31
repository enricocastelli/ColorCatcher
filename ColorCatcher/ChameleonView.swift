//
//  ChameleonView.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 31/10/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

// chameleon image original ratio: ratio 325:125

fileprivate var getChameleonHeight: CGFloat = {
    return UIScreen.main.bounds.height/10
}()
fileprivate var getChameleonWidth: CGFloat = {
    return UIScreen.main.bounds.height/5.5
}()
fileprivate var getChameleonY: CGFloat = {
    return UIScreen.main.bounds.height/4
}()

class ChameleonView: Animator {
    
    init() {
        let chameleonHeight = getChameleonHeight
        let chameleonWidth = getChameleonWidth
        let chFrame = CGRect(x: -chameleonWidth, y: getChameleonY, width: chameleonWidth, height: chameleonHeight)
        super.init(chFrame, imageName: "chameleon", count: 50, frameTime: 0.05)
    }
    
    func goToStatic() {
        self.image = UIImage(named: "chameleonX")
    }
    
    func changeColor(_ delay: Double? = nil) {
        let _ = Timer.scheduledTimer(withTimeInterval: 0, repeats: false) { (_) in
            UIView.transition(with: self,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.image = self.getRandomColor()
            },completion: nil)
        }
    }
    
    private func getRandomColor() -> UIImage? {
        let ar = [UIImage(named: "chameleonXPurple"),
                  UIImage(named: "chameleonXBlue"),
                  UIImage(named: "chameleonXBrown")]
        return ar.randomElement() ?? UIImage(named: "chameleonX")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
