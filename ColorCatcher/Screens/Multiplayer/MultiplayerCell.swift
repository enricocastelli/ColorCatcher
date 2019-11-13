//
//  MultiplayerCell.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 13/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.


import UIKit
import MultipeerConnectivity

protocol MultiplayerCellDelegate{
    func didTapVSButton(_ peer: MCPeerID)
}

class MultiplayerCell: UITableViewCell {
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var actionButton: BouncyButton!
    
    var delegate: MultiplayerCellDelegate?
    var shouldShowGroup = true
    var peer: MCPeerID? {
        didSet {
            guard let peer = peer else { return }
            playerLabel.text = peer.displayName
                actionButton.setTitle("VS", for: .normal)
                actionButton.backgroundColor = UIColor.CCCoral
                actionButton.isHidden = !shouldShowGroup
        }
    }
    
    override func awakeFromNib() {
        actionButton.set(0.2)
        super.awakeFromNib()
    }
    
    @IBAction func actionTapped(_ sender: BouncyButton) {
        guard let peer = peer else { return }
        delegate?.didTapVSButton(peer)
    }
    
}

