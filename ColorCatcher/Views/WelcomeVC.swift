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
    }
    
    @IBAction func DiscoveryTapped(_ sender: UIButton) {
        ColorManager.fetchColors(success: {
            self.pushToDiscoveryMode()
        }) {
            self.showGeneralError()
        }
    }
    
    func pushToDiscoveryMode() {
        let gameVC = GameDiscoveryVC()
        navigationController?.show(gameVC, sender: nil)
    }
    
    
}
