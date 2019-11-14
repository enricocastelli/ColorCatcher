//
//  MultiplayerVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 25/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit
import MultipeerConnectivity

fileprivate let cellID = String(describing: MultiplayerCell.self)
class MultiplayerVC: ColorController, PopupProvider {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roomButton: BouncyButton!
    @IBOutlet weak var explanationView: UIView!
    @IBOutlet weak var explanationLabel: UILabel!


    
    var multiplayer: MultiplayerManager!
    var players = [MCPeerID]() {
        didSet {
            self.hideExplanationView()
        }
    }
    lazy private var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        addRefresh()
        setExplanationView()
        setupMultiplayer()
        roomButton.setup()
        roomButton.setTitle("Create a Room", for: .normal)
    }
    

    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "")
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    func addRefresh() {
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func setExplanationView() {
        explanationView.alpha = 0
        explanationView.layer.cornerRadius = 20
        explanationLabel.text = "Be sure to be around other players and that Wi-Fi & Bluetooth are active!"
        let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
            self.showExplanationView()
        }
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
    
    @IBAction func startTapped(_ sender: BouncyButton) {
        for player in players {
            multiplayer.connect(player, room: true)
        }
    }
    
    func goToGame() {
        DispatchQueue.main.async {
            let gameVC = MultiGameVC(multiplayerManager: self.multiplayer)
            self.navigationController?.pushViewController(gameVC, animated: true)
        }
    }
    
    func showExplanationView() {
        guard players.isEmpty else { return }
        explanationView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.explanationView.alpha = 1
        }

    }
    
    func hideExplanationView() {
        UIView.animate(withDuration: 0.3) {
            self.explanationView.alpha = 0
        }
    }
}
    
extension MultiplayerVC: MultiplayerConnectionDelegate {
    
    func didFoundPeer(_ peer: MCPeerID) {
        guard !peerIsKnown(peer) else { return }
        players.append(peer)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didLostPeer(_ peer: MCPeerID) {
        guard peerIsKnown(peer) && players.contains(peer) else { return }
        players.remove(at: players.firstIndex(of: peer)!)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didReceiveInvitation(peerID: MCPeerID, room: Bool, invitationHandler: @escaping (Bool) -> ()) {
        let title = room ? "Multi game! 🎨" : "VS Game!"
        let messageString = room ? "You just received an invitation from: \(peerID.displayName) to join a multi game!" :
            "You just received an invitation from: \(peerID.displayName) to join a VS game"
        showAlert(title: title, message: messageString, firstButton: "Nope", secondButton: "Let's play!", firstCompletion: {
            invitationHandler(false)
        }) {
            invitationHandler(true)
        }
    }
    
    func didDisconnect(_ peer: MCPeerID, _ reason: DisconnectReason) {
        // handle cases
        if multiplayer.connectedPeerID.contains(peer) {
            multiplayer.connectedPeerID.remove(at: multiplayer.connectedPeerID.firstIndex(of: peer)!)
        }
        switch reason {
        case .RefusedInvite:
            showAlert(title: "Ops", message: "\(peer.displayName) didn't accept your invite!", firstButton: "Ok", secondButton: nil, firstCompletion: {
            }, secondCompletion: nil)
        case .Disconnect:
            showAlert(title: "Ops", message: "Connection with player stopped", firstButton: "Ok", secondButton: nil, firstCompletion: {
            }, secondCompletion: nil)
        }
    }
    
    func didConnect(_ peer: MCPeerID) {
        multiplayer.connectedPeerID.append(peer)
        if multiplayer.connectedPeerID.count == players.count {
            goToGame()
        }
    }
}

extension MultiplayerVC: UITableViewDelegate {}

extension MultiplayerVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MultiplayerCell
        cell.peer = players[indexPath.row]
        cell.delegate = self
        cell.shouldShowGroup = true
        cell.selectionStyle = .none
        return cell
    }
}

extension MultiplayerVC: MultiplayerCellDelegate {
    
    func didTapVSButton(_ peer: MCPeerID) {
        guard players.contains(peer) else { return }
        multiplayer.connect(peer, room: false)
    }
}
