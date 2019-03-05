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
    
    override func infoTapped(_ sender: UIButton) {
        //test
//        reset()
        CaptureManager.shared.stopSession()
        let collectionVC = ColorCollectionVC()
        navigationController?.show(collectionVC, sender: nil)
    }
    
    func nextColor() {
        ColorManager.updateColorWithLevel()
        updateColorView()
        CaptureManager.shared.startSession()
    }
    
    override func colorRecognized() {
        storeLevelUp()
        guard let currentColor = ColorManager.currentColor else { return }
        showAlert(title: "Well done!", message: currentColor.desc, firstButton: "Next!", secondButton: "Stop Here!", firstCompletion: {
            self.nextColor()
        }, secondCompletion: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
}

