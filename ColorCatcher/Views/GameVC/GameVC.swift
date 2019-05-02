//
//  ViewController.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 22/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox


// Superclass of the game happening
class GameVC: ColorController, AlertProvider, FlashProvider, UIGestureRecognizerDelegate {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: RoundProgress!
    @IBOutlet weak var skipButton: UIButton!
    
    var points = 0
    var gameStarted = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: String(describing: GameVC.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CaptureManager.shared.startSession()
        CaptureManager.shared.delegate = self
        ColorManager.shared.delegate = self
        progressView.alpha = 0
        addTapGesture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CaptureManager.shared.stopSession()
    }
    
    func addTapGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchToZoom(_:)))
        pinch.delegate = self
        let pinchView = UIView(frame: imageView.frame)
        self.view.addSubview(pinchView)
        pinchView.addGestureRecognizer(pinch)
    }
    
    @objc func pinchToZoom(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .changed {
            CaptureManager.shared.zoom(sender.velocity)
        }
    }
    
    func startGame() {
        ColorManager.shared.updateColor()
        updateColorView()
        UIView.animate(withDuration: 0.4) {
            self.progressView.alpha = 1
        }
    }
    
    func colorRecognized() {
        vibrate()
        showTimePopup()
        CaptureManager.shared.stopSession()
    }
    
    func updateColorView() {
        frameView.backgroundColor = ColorManager.shared.goalColor
        progressView.progressColor = ColorManager.shared.goalColor
    }
    
    func updatePoints() {
        points += 1
        updateCatchesLabel(points)
    }
    
    func updateProximityString(_ proximity: Float) {
        progressView.updateProgress(CGFloat(proximity*1.25))
    }
    
    func gameIsOver() {
        CaptureManager.shared.stopSession()
    }
    
    func new() {
        ColorManager.shared.updateColor()
        updateColorView()
        CaptureManager.shared.startSession()
    }
    
    func didDismissPopup() {
        //TO BE OVERRIDEN
        updatePoints()
        new()
    }
    
    //TO BE OVERRIDEN in discovery mode
    func showFinishColors() {}
    
    func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    @IBAction func helpTapped(_ sender: UIButton) {
        new()
    }
    
    
    @IBAction func infoTapped(_ sender: UIButton) {
        openFlash()
    }
    
}

extension GameVC: ColorRecognitionDelegate {
    
    func didRecognisedColor() {
        colorRecognized()
    }
    
    func didUpdateProximity(_ proximity: Double) {
        updateProximityString(Float(proximity))
    }
    
    
    func didFinishColors() {
        showFinishColors()
    }
}

extension GameVC: CaptureManagerDelegate {
    
    func processCapturedImage(image: UIImage) {
        if !gameStarted {
            gameStarted = true
            startGame()
        }
        DispatchQueue.main.async {
            self.imageView.image = image
            if let color = image.averageColor {
                self.colorView.backgroundColor = color
                ColorManager.shared.checkColor(color)
            }
        }
    }
    
    func failedInitializingSession() {
        showAlert(title: "Ops", message: "Seems like camera is not working.", firstButton: "Ok", secondButton: nil, firstCompletion: {
            self.navigationController?.popViewController(animated: true)
        }, secondCompletion: nil)
    }
}
