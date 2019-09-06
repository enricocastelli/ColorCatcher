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
    func opponentDidScorePoint()
    func opponentDidFinish()
}

protocol MultiplayerConnectionDelegate: class {
    func didFoundPeer(_ peer: MCPeerID)
    func didReceiveInvitation(peerID: MCPeerID, invitationHandler: @escaping (Bool) -> Void)
    func didDisconnect()
    func didConnect()
}

struct PlayerPoint: Codable {
    private var scored: String
    var didScore: Bool { get { return scored == "true" }}
}

struct PlayerFinish: Codable {
    private var finish: String
    var didFinish: Bool { get { return finish == "true" }}
}

class MultiplayerManager: NSObject {
    
    private let SessionName = "colorCatcher"
    
    let myPeerId = MCPeerID(displayName: UIDevice.current.name)
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
    
    public func sendName(_ name: String) {
        let playerName = UIDevice.current.name.lowercased()
        let params = ["displayName": playerName]
        self.sendData(params)
    }
    
    public func sendPoint() {
        let params = ["scored": "true"]
        self.sendData(params)
    }
    
    public func sendFinish() {
        let params = ["finish": "true"]
        self.sendData(params)
    }
    
    private func sendData(_ params: [String: String]) {
        if session.connectedPeers.count > 0 {
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
}

extension MultiplayerManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        connectionDelegate?.didReceiveInvitation(peerID: peerID, invitationHandler: { (accepted) in
            invitationHandler(accepted, self.session)
        })
    }
}

extension MultiplayerManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state.rawValue {
        case 0:
            Logger("Players Disconnected 🛑")
            connectionDelegate?.didDisconnect()
        case 1:
            Logger("Connecting...🔶")
        case 2:
            Logger("Players Connected ✅")
            connectionDelegate?.didConnect()
        default:
            break
        }
    }
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        processData(data: data) { (success) in
            if !success {
                Logger("Error decoding data received.")
            }
        }
    }
    
    func processData(data: Data, completion: @escaping(Bool) -> ()) {
        do {
            let _ = try JSONDecoder().decode(PlayerPoint.self, from: data)
            delegate?.opponentDidScorePoint()
            completion(true)
            return
        } catch {
        }
        do {
            let _ = try JSONDecoder().decode(PlayerFinish.self, from: data)
            delegate?.opponentDidFinish()
            completion(true)
            return
        } catch {
        }
        completion(false)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}

extension MultiplayerManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        Logger("Found peer \(peerID)")
        connectionDelegate?.didFoundPeer(peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }
}

