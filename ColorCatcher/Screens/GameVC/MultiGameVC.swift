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
    
    var multiplayer: MultiplayerManager
    let pointsToWin: Int
    var gameOver = false
    var shouldShowDisconnectAlert = true
    
    init(multiplayerManager: MultiplayerManager) {
        multiplayer = multiplayerManager
        pointsToWin = multiplayer.connectedPeerID.count*3
        super.init(nibName: String(describing: GameVC.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarForMultiplayer(multiplayer.connectedPeerID.names())
        multiplayer.updateDelegate(delegate: self, connectionDelegate: self)
    }
    
    override func colorRecognized() {
        super.colorRecognized()
        updatePoints()
        sendScorePoint()
        showPopup(PopupModel.plusOne(0.8))
    }
    
    override func updatePoints() {
        points += 1
        updateMultiplayerLabel(points)
    }
    
    override func helpTapped(_ sender: UIButton) {
        points -= 1
        updateMultiplayerLabel(points)
        sendScorePoint()
    }
    
    func sendScorePoint() {
        multiplayer.sendPoint(points)
    }
    
    override func didDismissPopup() {
        if points >= pointsToWin {
            multiplayer.sendFinish()
            showAlertEnd("", userDidWin: true)
        } else {
            new()
        }
    }
    
    func showAlertEnd(_ winner: String, userDidWin: Bool) {
        gameOver = true
        CaptureManager.shared.stopSession()
        let title = userDidWin ? "YAS!" : "OUCH!"
        let message = userDidWin ? "You won!" : "\(winner) Won!"
        showAlert(title: title, message: message, firstButton: "Ok", secondButton: nil, firstCompletion: {
            self.multiplayer.stop()
            self.navigationController?.popToRootViewController(animated: true)
        }, secondCompletion: nil)
    }
    
    override func backTapped(_ sender: UIButton) {
        showAlert(title: "Sure?", message: "If you leave the game you will lose the game!", firstButton: "Exit", secondButton: "Keep Playing", firstCompletion: {
            self.multiplayer.stop()
            self.shouldShowDisconnectAlert = false
            self.navigationController?.popToRootViewController(animated: true)
        }) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension MultiGameVC: MultiplayerDelegate {
    
    func opponentDidScorePoint(_ opponent: String, point: Int) {
        DispatchQueue.main.async {
            self.updateOpponentLabel(opponent, point)
        }
    }
    
    func opponentDidFinish(_ opponent: String) {
        showAlertEnd(opponent, userDidWin: false)
    }
}

extension MultiGameVC: MultiplayerConnectionDelegate {
    
    
    func didConnect(_ peer: MCPeerID) {}
    func didFoundPeer(_ peer: MCPeerID) { }
    func didLostPeer(_ peer: MCPeerID) {}
    
    func didReceiveInvitation(peerID: MCPeerID, room: Bool, invitationHandler: @escaping (Bool) -> ()) {}
    
    func didDisconnect(_ peer: MCPeerID, _ reason: DisconnectReason) {
        guard shouldShowDisconnectAlert else { return }
        multiplayer.connectedPeerID.remove(at: multiplayer.connectedPeerID.firstIndex(of: peer)!)
        guard multiplayer.connectedPeerID.isEmpty else { return }
        multiplayer.stop()
        if !gameOver {
            showAlert(title: "Ops", message: "Connection stopped!", firstButton: "Back", secondButton: nil, firstCompletion: {
                self.navigationController?.popToRootViewController(animated: true)
            }, secondCompletion: nil)
        }
    }
}

