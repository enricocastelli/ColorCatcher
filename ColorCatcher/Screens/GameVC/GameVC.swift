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
class GameVC: ColorController, PopupProvider, FlashProvider, UIGestureRecognizerDelegate {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: RoundProgress!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    
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
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CaptureManager.shared.stopSession()
    }
    
    func addTapGesture() {
        let pinch = UIPanGestureRecognizer(target: self, action: #selector(pinchToZoom(_:)))
        pinch.delegate = self
        let pinchView = UIView(frame: imageView.frame)
        self.view.addSubview(pinchView)
        pinchView.addGestureRecognizer(pinch)
    }
    
    @objc func pinchToZoom(_ sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            CaptureManager.shared.zoom(sender.velocity(in: imageView).y)
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
        showPopup(PopupModel.empty())
        CaptureManager.shared.stopSession()
        setFlashIcon(false)
        // TODO:
        imageView.image = UIImage(named: "chameleonX")
    }
    
    func updateColorView() {
        UIView.animate(withDuration: 0.4) {
            self.frameView.backgroundColor = ColorManager.shared.goalColor
            self.progressView.progressColor = ColorManager.shared.goalColor
        }
    }
    
    func updatePoints() {
        points += 1
        updateCatchesLabel(points)
    }
    
    func updateProximityString(_ proximity: Float) {
        progressView.updateProgress(CGFloat((proximity/100)*1.05))
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
        openFlash { (on) in
            self.setFlashIcon(on)
        }
    }
    
    func setFlashIcon(_ on: Bool) {
        flashButton.isSelected = on
        flashButton.tintColor = on ? .blue : .darkGray
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

