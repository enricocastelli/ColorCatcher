//
//  GameDiscoveryVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 27/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class GameDiscoveryVC: GameVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreView.isHidden = true
        Service.shared.get(success: { (data) in
            
        }) { (error) in
            
        }
    }
    
    override func colorRecognized() {
        //show alert knowing more about that color
    }
    
}

