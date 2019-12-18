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
        nextColor()
        updateColorView()
        skipButton.alpha = Service.shared.isSkippingEnabled() ? 1 : 0
        configureBarForDiscovery()
    }
    
    override func startGame() {
        updateColorView()
        UIView.animate(withDuration: 0.4) {
            self.progressView.alpha = 1
        }
    }
    
    override func applyLevel() {
        ColorManager.shared.tolerance = {
            let level = getLevel()
            switch level {
            case 0: return 90
            case 1: return 94
            case 2: return 98
            default: return 94
            }
        }()
    }
    
    override func helpTapped(_ sender: UIButton) {
        colorRecognized()
    }
    
    override func didDismissPopup() {
        nextColor()
    }
    
    override func backTapped(_ sender: UIButton) {
        super.backTapped(sender)
    }
    
    func nextColor() {
        gamePaused = false
        CaptureManager.shared.startSession()
        ColorManager.shared.updateNextColor()
        updateColorView()
    }
    
    override func colorRecognized() {
        super.colorRecognized()
        logEvent(.DiscoveryColorCatched)
        gamePaused = true
        updateCollectionLabel()
        guard let currentColor = ColorManager.shared.currentColor else { return }
        storeColorCatched(Catched(hex: currentColor.hex))
        presentPopup(currentColor)
    }
    
    func presentPopup(_ currentColor: ColorModel) {
        var model = PopupModel(titleString: currentColor.name, message: currentColor.description)
        model.color = UIColor(hex: currentColor.hex)
        showPopup(model)
    }
    
    override func showFinishColors() {
        CaptureManager.shared.stopSession()
        frameView.backgroundColor = UIColor.white
        showAlert(title: "Game is Over!", message: "You finished all colors", firstButton: "Reset", secondButton: "Back", firstCompletion: {
            self.reset()
            self.backTapped(self.backArrow)
        }) {
            self.backTapped(self.backArrow)
        }
    }
}

