//
//  ViewController.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 22/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit
import AVFoundation


// Superclass of the game happening
class GameVC: UIViewController, AlertProvider {

    @IBOutlet weak var expectedColorView: RoundView!
    @IBOutlet weak var colorView: RoundView!
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colorViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    var points = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: String(describing: GameVC.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CaptureManager.shared.delegate = self
        setLayers()
        ColorManager.delegate = self
        let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
            self.startGame()
        })
    }
    
    func startGame() {
        ColorManager.updateColor()
        updateColorView()
        CaptureManager.shared.startSession()
    }
    
    func setLayers() {
        expectedColorView.layer.borderColor = UIColor.white.cgColor
        expectedColorView.layer.borderWidth = 1
        colorView.layer.borderColor = UIColor.black.cgColor
        colorView.layer.borderWidth = 1
        progressView.layer.borderWidth = 1
        progressView.layer.borderColor = UIColor.black.cgColor
        progressView.layer.cornerRadius = 20
        progressView.clipsToBounds = true
        progressView.progress = 0
    }
    
    func colorRecognized() {
        ColorManager.updateColor()
        updatePoints()
        updateColorView()
    }
    
    func updateColorView() {
        expectedColorView.backgroundColor = ColorManager.goalColor
        progressView.progressTintColor = ColorManager.goalColor
    }
    
    func updatePoints() {
        points += 1
        pointLabel.text = "\(points)"
    }
    
    func updateProximityString() {
        progressView.progress = ColorManager.getColorProximity()
    }
    
    func gameIsOver() {
        CaptureManager.shared.stopSession()
    }
    
    func new() {
        ColorManager.updateColor()
        updateColorView()
        CaptureManager.shared.startSession()
    }
    
    @IBAction func helpTapped(_ sender: UIButton) {
        new()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        CaptureManager.shared.stopSession()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func infoTapped(_ sender: UIButton) {
        didRecognisedColor()
    }
}

extension GameVC: ColorRecognitionDelegate {
    
    func didRecognisedColor() {
        colorRecognized()
    }
    
    func didUpdateProximity(_ proximity: Float) {
        self.updateProximityString()
    }
}

extension GameVC: CaptureManagerDelegate {
    
    func processCapturedImage(image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
            if let color = image.averageColor {
                self.colorView.backgroundColor = color
                ColorManager.checkColor(color)
            }
        }
    }
}

