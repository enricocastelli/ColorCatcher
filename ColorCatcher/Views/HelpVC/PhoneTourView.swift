//
//  PhoneTourView.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 03/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit


class PhoneTourView: UIView {
    
    var view: UIView!
    
    @IBOutlet weak var phoneImage: UIImageView!
    
    @IBOutlet weak var doneImage: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    func nibSetup() {
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func startAnimation() {
        doneImage.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        self.frame.origin.x = UIScreen.main.bounds.width
        firstAnimation()
    }
    
    func firstAnimation() {
        UIView.animate(withDuration: 4, delay: 2, options: .curveEaseOut, animations: {
            self.center.x = 0
        }) { (_) in
            self.secondAnimation()
        }
    }
    
    func secondAnimation() {
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseOut, animations: {
            self.center.x = UIScreen.main.bounds.width/1.8
        }) { (_) in
            self.showColorDone()
        }
    }
    
    func showColorDone() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            self.doneImage.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (_) in
            self.hide()
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.center.y = UIScreen.main.bounds.height/2 + 16
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.frame.origin.y = UIScreen.main.bounds.height
            })
        }
    }
}
