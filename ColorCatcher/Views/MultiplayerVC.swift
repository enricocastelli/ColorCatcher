//
//  MultiplayerVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 25/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultiplayerVC: ColorController, PopupProvider {
    
    @IBOutlet weak var tableView: UITableView!
    var multiplayer: MultiplayerManager!
    var players : Array<MCPeerID> = []
    lazy private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setupMultiplayer()
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func peerIsKnown(_ peer: MCPeerID) -> Bool {
        let isKnown = players.contains(where: { (peer1) -> Bool in
            return peer1.displayName == peer.displayName
        })
        return isKnown && !players.isEmpty
    }
    
    func setupMultiplayer() {
        multiplayer = MultiplayerManager(delegate: nil, connectionDelegate: self)
    }
    
    override func backTapped(_ sender: UIButton) {
        multiplayer.stop()
        super.backTapped(sender)
    }
    
    @objc func refresh(_ sender:AnyObject) {
        players = []
        multiplayer.stop()
        multiplayer.start()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension MultiplayerVC: MultiplayerConnectionDelegate {
    
    func didFoundPeer(_ peer: MCPeerID) {
        guard !peerIsKnown(peer) else { return }
        players.append(peer)
        tableView.reloadData()
    }
    
    func didReceiveInvitation(peerID: MCPeerID, invitationHandler: @escaping (Bool) -> Void) {
        showAlert(title: "Hello! 🎨", message: "You just received an invitation game from: \(peerID.displayName).", firstButton: "Nope", secondButton: "Let's play!", firstCompletion: {
            invitationHandler(false)
        }) {
            invitationHandler(true)
        }
    }
    
    func didDisconnect() {
        showAlert(title: "Ops", message: "Connection with plaayer stopped", firstButton: "Ok", secondButton: nil, firstCompletion: {
        }, secondCompletion: nil)
    }
    
    func didConnect() {
        DispatchQueue.main.async {
            let gameVC = MultiGameVC(multiplayerManager: self.multiplayer)
            self.navigationController?.show(gameVC, sender: nil)
        }
    }
}

extension MultiplayerVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peerID = players[indexPath.row]
        multiplayer.connectedPeerID = peerID
        multiplayer.connect(peerID)
    }
}

extension MultiplayerVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = players[indexPath.row].displayName
        cell.selectionStyle = .none
        return cell
    }
    
}
