//
//  MultiGameVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 27/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class MultiGameVC: GameVC {
    
    var oppPoints = 0
    var multiplayer: MultiplayerManager
    var gameOver = false
    
    init(multiplayerManager: MultiplayerManager) {
        multiplayer = multiplayerManager
        super.init(nibName: String(describing: GameVC.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarForMultiplayer(multiplayer.connectedPeerID?.displayName)
        multiplayer.updateDelegate(delegate: self, connectionDelegate: self)
    }
    
    override func colorRecognized() {
        super.colorRecognized()
        sendScorePoint()
    }
    
    override func updatePoints() {
        points += 1
        updateMultiplayerLabel(points)
    }
    
    func sendScorePoint() {
        multiplayer.sendPoint()
    }
    
    override func didDismissPopup() {
        updatePoints()
        if points == 3 {
            multiplayer.sendFinish()
            showAlertEnd(winner: true)
        } else {
            new()
        }
    }
    
    
    func showAlertEnd(winner: Bool) {
        gameOver = true
        CaptureManager.shared.stopSession()
        let title = winner ? "YAS!" : "OUCH!"
        let message = winner ? "You just won \(points) to \(oppPoints)!" : "You lost \(oppPoints) to \(points)!"
        showAlert(title: title, message: message, firstButton: "Ok", secondButton: nil, firstCompletion: {
            self.multiplayer.stop()
            self.navigationController?.popToRootViewController(animated: true)
        }, secondCompletion: nil)
    }
    
    override func backTapped(_ sender: UIButton) {
        multiplayer.stop()
        super.backTapped(sender)
    }
    
}

extension MultiGameVC: MultiplayerDelegate {
    
    func opponentDidScorePoint() {
        oppPoints += 1
        DispatchQueue.main.async {
            self.updateOpponentLabel(self.oppPoints)
        }
    }
    
    func opponentDidFinish() {
        showAlertEnd(winner: false)
    }
}

extension MultiGameVC: MultiplayerConnectionDelegate {
    
    func didFoundPeer(_ peer: MCPeerID) { }
    
    func didReceiveInvitation(peerID: MCPeerID, invitationHandler: @escaping (Bool) -> Void) { }
    
    func didDisconnect() {
        multiplayer.stop()
        if !gameOver {
            showAlert(title: "Ops", message: "Connection stopped!", firstButton: "Back", secondButton: nil, firstCompletion: {
                self.navigationController?.popViewController(animated: true)
            }, secondCompletion: nil)
        }
    }
    
    func didConnect() { }
}

