//
//  ScoreLabel.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 13/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class ScoreLabel: UILabel {
    
    var opponent = ""
    var points = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func isOpponent(_ opp: String) -> Bool {
        return opponent == opp
    }
    
    func updatePoints(_ points: Int) {
        self.points = points
        updateText()
    }
    
    private func updateText() {
        font = UIFont.regularFont(size: 14)
        textColor = UIColor.gray
        text = "\(opponent): \(points)"
    }
    
}
