//
//  NavC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 30/04/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class NavBar: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBar()
        setBackButton()
        setButtons()
        navigationController?.navigationBar.topItem?.hidesBackButton = true
    }
    

    
}

