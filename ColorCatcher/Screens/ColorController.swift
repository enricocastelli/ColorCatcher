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
    @IBOutlet weak var rightLabel: ScoreLabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
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
        stackView.isHidden = true
        centerView.isHidden = true
        rightView.isHidden = true
        centerImage.tintColor = UIColor.lightGray
        rightImage.tintColor = UIColor.lightGray
        backArrow.tintColor = UIColor.lightGray
        addGradient()
    }
    
    private func addNib() {
        barView = Bundle.main.loadNibNamed("BarView", owner: self, options: nil)?.first as? UIView
        self.containerView?.addContentView(barView!)
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
    
    func configureBarForMultiplayer(_ opponents: [String]) {
        centerView.isHidden = false
        rightView.isHidden = true
        stackView.isHidden = false
        centerImage.image = UIImage(named: "painter-palette")
        centerImage.tintColor = UIColor.CCWater
        centerLabel.text = "Me: 0"
        rightLabel.text = ""
        for opponent in opponents {
            let label = ScoreLabel(frame: stackView.frame)
            label.opponent = opponent
            label.updatePoints(0)
            stackView.insertArrangedSubview(label, at: 0)
        }
    }
    
    private func addGradient() {
        let gradient = GradientView()
        self.barView?.backgroundColor = UIColor.clear
        self.barView?.addContentView(gradient, 0)
//        let blur = BlurredView(frame: self.containerView!.frame)
//        self.barView?.layer.insertSublayer(blur.layer, above: gradient)
    }
    
    func updateTimeLabel(_ time: Int) {
        rightLabel.text = "\(time)"
    }
    
    func updateCatchesLabel(_ catches: Int) {
        centerLabel.text = "\(catches) Catches"
    }
    
    func updateOpponentLabel(_ opponent: String,_ catches: Int) {
        for label in stackView.subviews as? [ScoreLabel] ?? [] {
            if label.isOpponent(opponent) {
                label.updatePoints(catches)
            }
        }
        order()
    }
    
    func order() {
        guard var labels = stackView.subviews as? [ScoreLabel] else { return }
        labels.sort(by: { ($0.points < $1.points)})
        stackView.clear()
        stackView.add(labels)
    }
    
    func updateMultiplayerLabel(_ catches: Int) {
        centerLabel.text = "Me: \(catches)"
    }
    
    func updateCollectionLabel() {
        rightLabel.text = "\(retrieveColorCatched().count)/\(ColorManager.shared.colors.count)"
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

