//
//  GameTimeVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 27/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class GameTimeVC: GameVC {
    
    var timerExpired = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarForRace()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ColorTimer.shared.invalidate()
    }
    
    override func startGame() {
        super.startGame()
        ColorTimer.shared.delegate = self
        ColorTimer.shared.fire()
        ColorManager.shared.tolerance = 0.8
    }
    
    override func didDismissPopup() {
        //TO BE OVERRIDEN
        updatePoints()
        guard !timerExpired else {
            timerIsExpired()
            return
        }
        new()
    }
    
    func updateTimerLabel(_ seconds: Int) {
        updateTimeLabel(seconds)
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
    
    func timerIsExpired() {
        timerExpired = true
        CaptureManager.shared.stopSession()
        showAlert(title: "Time is up!", message: "You catched \(points) colors", firstButton: "Yay", secondButton: nil, firstCompletion: {
            self.navigationController?.popToRootViewController(animated: true)
        }, secondCompletion: nil)
    }
    
    func timerUpdate(_ seconds: Int) {
        updateTimerLabel(seconds)
    }
}
