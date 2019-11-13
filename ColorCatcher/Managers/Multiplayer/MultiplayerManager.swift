//
//  MultiplayerManager.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 25/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MultiplayerDelegate: class {
    func opponentDidScorePoint(_ opponent: String, point: Int)
    func opponentDidFinish(_ opponent: String)
}

protocol MultiplayerConnectionDelegate: class {
    func didFoundPeer(_ peer: MCPeerID)
    func didLostPeer(_ peer: MCPeerID)
    func didReceiveInvitation(peerID: MCPeerID, invitationHandler: @escaping (Bool) -> Void)
    func didDisconnect(_ peer: MCPeerID, _ reason: DisconnectReason)
    func didConnect(_ peer: MCPeerID)
}


class MultiplayerManager: NSObject {
    
    private let SessionName = "colorCatcher"
    
    let myPeerId = MCPeerID(displayName: UIDevice.current.name.multiplayerName)
    var connectedPeerID = [MCPeerID]()
    private var serviceAdvertiser : MCNearbyServiceAdvertiser!
    private var serviceBrowser : MCNearbyServiceBrowser!
    
    var session : MCSession
    
    weak var delegate: MultiplayerDelegate?
    weak var connectionDelegate: MultiplayerConnectionDelegate?
    
    init(delegate: MultiplayerDelegate?, connectionDelegate: MultiplayerConnectionDelegate?) {
        self.delegate = delegate
        self.connectionDelegate = connectionDelegate
        session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .none)
        super.init()
        session.delegate = self
        start()
    }
    
    func updateDelegate(delegate: MultiplayerDelegate?, connectionDelegate: MultiplayerConnectionDelegate?) {
        self.delegate = delegate
        self.connectionDelegate = connectionDelegate
    }
    
    func start() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: SessionName)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: SessionName)
        stop()
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    func stop() {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
        self.session.disconnect()
    }
    
    
    func connect(_ peerID: MCPeerID) {
        serviceBrowser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    public func sendPoint(_ points: Int) {
        let data = DataCodable(name: myPeerId.displayName, finish: false, points: points)
        self.sendData(data)
    }
    
    public func sendFinish() {
        let params = DataCodable(name: myPeerId.displayName, finish: true, points: 0)
        self.sendData(params)
    }
    
    private func sendData<T: Codable>(_ params: T) {
        guard !session.connectedPeers.isEmpty else {
            return
        }
        do {
            let data = try JSONEncoder().encode(params)
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                Logger("\(error) error sending Data")
            }
        } catch {
            Logger("\(error) error sending Data")
        }
    }
}
