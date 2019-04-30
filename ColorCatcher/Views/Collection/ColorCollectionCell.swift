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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        colorView.backgroundColor = UIColor.groupTableViewBackground
        colorLabel.text = "??????"
        colorNameLabel.text = ""
    }
    
    func animateShowing() {
        colorView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        colorView.alpha = 0
        let rand = Double(arc4random_uniform(5) + 2)/10
        UIView.animate(withDuration: rand, delay: 0, options: .curveEaseOut, animations: {
            self.colorView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.colorView.alpha = 1
        }) { (done) in
            
        }
    }
    
    func animateFading() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.colorView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.colorView.alpha = 0
        }) { (done) in
            
        }
    }

}
