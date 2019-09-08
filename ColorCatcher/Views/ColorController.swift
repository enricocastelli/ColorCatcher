//
//  NavC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 30/04/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class ColorController: UIViewController, StoreProvider {
    
    @IBOutlet weak var containerView: UIView?
    @IBOutlet weak var backArrow: UIButton!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    
    var gradient: CAGradientLayer?
    var barView: UIView?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard containerView != nil else {
            Logger("Navigation bar is not implemented!")
            return
        }
        addNib()
        centerView.isHidden = true
        rightView.isHidden = true
        centerImage.tintColor = UIColor.lightGray
        rightImage.tintColor = UIColor.lightGray
        backArrow.tintColor = UIColor.lightGray
    }
    
    private func addNib() {
        barView = Bundle.main.loadNibNamed("BarView", owner: self, options: nil)?.first as? UIView
        self.containerView?.addSubview(barView!)
    }
    
    func configureBarForRace() {
        centerView.isHidden = false
        rightView.isHidden = false
        centerImage.image = UIImage(named: "painter-palette")
        centerLabel.text = "0 Catches"
        rightImage.image = UIImage(named: "time")
        rightLabel.text = "60"
    }
    
    func configureBarForDiscovery() {
        centerView.isHidden = true
        rightView.isHidden = false
        rightImage.image = UIImage(named: "painter-palette")
        updateCollectionLabel()
    }
    
    func configureBarForCollection() {
        configureBarForDiscovery()
    }
    
    func configureBarForMultiplayer(_ opponentName: String?) {
        centerView.isHidden = false
        rightView.isHidden = false
        centerImage.image = UIImage(named: "painter-palette")
        centerImage.tintColor = UIColor.CCWater
        centerLabel.text = "Me: 0"
        rightImage.image = UIImage(named: "high-five")
        rightImage.tintColor = UIColor.CCWater
        rightLabel.text = "Opp: 0"
    }
    
    private func addGradient() {
        gradient = CAGradientLayer()
        gradient!.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient!.locations = [0.2,1]
        gradient!.frame = self.containerView!.frame
        self.barView?.backgroundColor = UIColor.clear
        self.barView?.layer.insertSublayer(gradient!, at: 0)
    }
    
    func updateTimeLabel(_ time: Int) {
        rightLabel.text = "\(time)"
    }
    
    func updateCatchesLabel(_ catches: Int) {
        centerLabel.text = "\(catches) Catches"
    }
    
    func updateOpponentLabel(_ catches: Int) {
        rightLabel.text = "Opp: \(catches)"
    }
    
    func updateMultiplayerLabel(_ catches: Int) {
        centerLabel.text = "Me: \(catches)"
    }
    
    func updateCollectionLabel() {
        rightLabel.text = "\(retrieveLevel())/\(ColorManager.shared.colors.count)"
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

