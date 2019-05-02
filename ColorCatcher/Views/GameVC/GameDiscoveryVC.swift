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
        ColorManager.shared.tolerance = 0.85
        nextColor()
        updateColorView()
        configureBarForDiscovery()
    }
    
    override func startGame() {
        updateColorView()
        UIView.animate(withDuration: 0.4) {
            self.progressView.alpha = 1
        }
    }
    
    override func new() {
        colorRecognized()
    }
    
    override func didDismissPopup() {
        nextColor()
    }
    
    override func backTapped(_ sender: UIButton) {
        super.backTapped(sender)
    }
    
    func nextColor() {
        ColorManager.shared.updateColorWithLevel()
        updateColorView()
        CaptureManager.shared.startSession()
    }
    
    override func colorRecognized() {
        vibrate()
        CaptureManager.shared.stopSession()
        storeLevelUp()
        updateCollectionLabel()
        guard let currentColor = ColorManager.shared.currentColor else { return }
        showPopup(titleString: currentColor.name, message: currentColor.desc, button: "", color: UIColor(hex: currentColor.hex))
    }
    
    override func showFinishColors() {
        showAlert(title: "Game is Over!", message: "You finished all colors", firstButton: "Reset", secondButton: "Back", firstCompletion: {
            self.reset()
            self.backTapped(self.backArrow)
        }) {
            self.backTapped(self.backArrow)
        }
    }
}

