//
//  WelcomeVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 25/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import Foundation
import UIKit

class WelcomeVC: UIViewController, AlertProvider {
    
    @IBAction func raceTapped(_ sender: UIButton) {
        let gameVC = GameTimeVC()
        navigationController?.show(gameVC, sender: nil)
//        showTestPopup()
    }
    
    @IBAction func DiscoveryTapped(_ sender: UIButton) {
        ColorManager.fetchColors(success: {
            self.pushToDiscoveryMode()
        }) {
            self.showGeneralError()
        }
    }
    
    func didDismissPopup() {
    }
    
    
    func pushToDiscoveryMode() {
        let gameVC = GameDiscoveryVC()
        navigationController?.show(gameVC, sender: nil)
    }
    
    func animation() {
        let center = self.view.center.x
        let red = UIImageView(frame: CGRect(x: center - 100, y: 90, width: 120, height: 120))
        let blue = UIImageView(frame: CGRect(x: center - 50, y: 140, width: 150, height: 150))
        let green = UIImageView(frame: CGRect(x: center - 40, y: 50, width: 160, height: 160))
        
        red.image = UIImage(named: "red")
        green.image = UIImage(named: "green")
        blue.image = UIImage(named: "blue")

        red.alpha = 0
        blue.alpha = 0
        green.alpha = 0


        self.view.addSubview(red)
        self.view.addSubview(green)
        self.view.addSubview(blue)

        UIView.animate(withDuration: 0.3, animations: {
            red.alpha = 1
        }) { (done) in
            green.alpha = 1
            UIView.animate(withDuration: 0.2, animations: {
                blue.alpha = 1
            })
        }
    }
}
