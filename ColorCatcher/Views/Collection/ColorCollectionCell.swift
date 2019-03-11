//
//  ColorCollectionCell.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 01/03/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class ColorCollectionCell: UICollectionViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorNameLabel: UILabel!
    
    var color: ColorModel? {
        didSet {
            guard let color = color else { return }
            colorView.backgroundColor = UIColor(hex: color.hex)
            colorLabel.text = color.hex.uppercased()
            colorNameLabel.text = color.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorLabel.text = "??????"
        colorNameLabel.text = ""
    }

}
