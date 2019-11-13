//
//  SessionDelegate.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 13/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import Foundation
import MultipeerConnectivity

extension MultiplayerManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state.rawValue {
        case 0:
            Logger("Players Disconnected 🛑")
            let reason = connectedPeerID.isEmpty ? DisconnectReason.Disconnect : DisconnectReason.RefusedInvite
            connectionDelegate?.didDisconnect(peerID, reason)
        case 1:
            Logger("Connecting...🔶")
        case 2:
            Logger("Players Connected ✅")
            connectionDelegate?.didConnect(peerID)
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
            let data = try JSONDecoder().decode(DataCodable.self, from: data)
            if data.finish {
                delegate?.opponentDidFinish(data.name)
            } else {
                delegate?.opponentDidScorePoint(data.name, point: data.points)
            }
            completion(true)
            return
        } catch {
            Logger(error)
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
