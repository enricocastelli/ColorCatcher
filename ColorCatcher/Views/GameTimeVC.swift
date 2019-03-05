//
//  GameTimeVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 27/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit
import AudioToolbox

class GameTimeVC: GameVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func startGame() {
        super.startGame()
        ColorTimer.shared.delegate = self
        ColorTimer.shared.fire()
        secondLabel.text = "\(ColorTimer.shared.seconds)"
    }
    
    func updateTimerLabel(_ seconds: Int) {
        secondLabel.text = "\(seconds)"
    }
    
    override func gameIsOver() {
        super.gameIsOver()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        showAlert(title: "Time is up!", message: "You catched \(points) colors", firstButton: "Yay", secondButton: nil, firstCompletion: {
            self.navigationController?.popToRootViewController(animated: true)
        }, secondCompletion: nil)
    }
    
    override func helpTapped(_ sender: UIButton) {
        super.helpTapped(sender)
        ColorTimer.shared.applyPenalty()
    }
    
    override func backTapped(_ sender: UIButton) {
        ColorTimer.shared.invalidate()
        super.backTapped(sender)
    }
}

extension GameTimeVC: ColorTimerDelegate {
    
    func timerUpdate(_ seconds: Int) {
        updateTimerLabel(seconds)
    }
}
