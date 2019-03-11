//
//  GameDiscoveryVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 27/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class GameDiscoveryVC: GameVC, StoreProvider {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ColorManager.shared.tolerance = 0.7
        scoreView.isHidden = true
        updateColorView()
    }
    
    override func startGame() {
        updateColorView()
        CaptureManager.shared.startSession()
    }
    
    override func new() {
        colorRecognized()
    }
    
    override func didDismissPopup() {
        nextColor()
    }
    
    override func backTapped(_ sender: UIButton) {
        super.backTapped(sender)
        reset()
    }
    
    override func infoTapped(_ sender: UIButton) {
        let collectionVC = ColorCollectionVC()
        navigationController?.show(collectionVC, sender: nil)
    }
    
    func nextColor() {
        ColorManager.shared.updateColorWithLevel()
        updateColorView()
        CaptureManager.shared.startSession()
    }
    
    override func colorRecognized() {
        CaptureManager.shared.stopSession()
        storeLevelUp()
        guard let currentColor = ColorManager.shared.currentColor else { return }
        showPopup(titleString: currentColor.name, message: currentColor.desc, button: "")
    }
}

