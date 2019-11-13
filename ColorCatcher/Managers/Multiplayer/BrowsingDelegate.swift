//
//  BrowsingDelegate.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 13/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import Foundation
import MultipeerConnectivity

extension MultiplayerManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        connectionDelegate?.didReceiveInvitation(peerID: peerID, invitationHandler: { (accepted) in
            invitationHandler(accepted, self.session)
        })
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
        connectionDelegate?.didLostPeer(peerID)
    }
}
