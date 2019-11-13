//
//  MultiplayerModel.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 13/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import Foundation
import MultipeerConnectivity

struct DataCodable: Codable {
    var name: String
    var finish: Bool
    var points: Int
}

extension Array where Element == MCPeerID {
    
    func names() -> [String] {
        return self.map({ (peer) -> String in
            return peer.displayName
        })
    }
}

enum DisconnectReason {
    case RefusedInvite, Disconnect
}

