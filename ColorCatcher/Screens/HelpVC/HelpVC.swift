//
//  HelpVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 30/04/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit
import AVFoundation // for Authorization on using camera
import CoreLocation // for Authorization on location

fileprivate let texts: [String] = ["You will be given a color to find and catch",
                                          "Look for that color around you...",
                                          "And point your phone on it!",
                                          "Collect all colors and find out cool facts about them you would never imagined",
                                          "Please enable camera access",
                                            "...and location", "", ""]

class HelpVC: UIViewController, DropProvider {
    
    @IBOutlet weak var continueButton: BouncyButton!
    @IBOutlet weak var titleLabel: UILabel!

    var step = 0
    var timer = Timer()
    var timing = 3.0
    
    var phoneView: PhoneTourView?
    var apples = [AppleImageView]()
    var drops = [DropLayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.setTitle("Skip Intro", for: .normal)
        continueButton.setup()
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        start()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(locationStatusDidChange),
                                               name: .locationStatusDidChange,
                                               object: nil)
    }
    
    
    func start() {
        titleLabel.changeText("Welcome to ColorCatcher!")
        // animate chameleon?
        setTimer()
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timing, repeats: true) { (_) in
            self.timerCallback()
        }
    }
    
    func timerCallback() {
        nextStep()
        step += 1
    }
    
    func nextStep() {
        titleLabel.changeText(texts[step])
        switch step {
        case 0:
            addPhoneView()
            addAppleImage()
        case 1, 2: break // wait
        case 3:
            removeImages()
            addDrops()
        case 4:
            removeDrops()
            timer.invalidate()
            if hasPermission() {
                pushFoward()
            } else {
                askCameraPermissions()
            }
        case 5: askLocationPermissions()
        case 6: pushFoward()
        default:
            Logger("step not expected during Tour \(step)")
            pushFoward()
            break
        }
    }

    func addPhoneView() {
        let width = UIScreen.main.bounds.width
        let phoneFrame = CGRect(x: width, y: 0, width: width, height: width)
        phoneView = PhoneTourView(frame: phoneFrame)
        phoneView!.center.y = self.view.center.y/0.9
        view.addSubview(phoneView!)
        phoneView!.startAnimation(3.5, 3.0, delay: 0.5)
    }
    
    func addAppleImage() {
        let width = UIScreen.main.bounds.width
        let appleFrame = CGRect(x: width, y: -width, width: width, height: width)
        self.apples = [AppleImageView(appleFrame, .Green, 0.7),
                       AppleImageView(appleFrame, .Yellow, 0.5),
                       AppleImageView(appleFrame, .Red, 0.6)]
        for apple in apples {
            self.view.insertSubview(apple, at: 0)
        }
    }
    
    func addDrops() {
        let layer = CAShapeLayer()
        layer.opacity = 0.7
        view.layer.insertSublayer(layer, at: 0)
        drops = addDropSet(100, masterLayer: layer)
    }
    
    func removeImages() {
        phoneView?.removeFromSuperview()
        for apple in apples { apple.removeFromSuperview() }
    }
    
    func removeDrops() {
        for drop in drops {
            drop.fade()
        }
    }
    
    func animateChameleon() {
        let chameleon = ChameleonView()
        chameleon.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        chameleon.center = self.view.center
        self.view.addSubview(chameleon)
        chameleon.alpha = 0
        chameleon.start(0.03)
        UIView.animate(withDuration: 2) {
            chameleon.alpha = 1
        }
    }
    
    func hasPermission() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized ||
            AVCaptureDevice.authorizationStatus(for: .video) == .denied
    }
    
    func askLocationPermissions() {
        let _ = LocationManager.shared
    }
    
    func askCameraPermissions() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            DispatchQueue.main.async {
                self.timerCallback()
            }
        })
    }
    
    @objc func locationStatusDidChange() {
        timerCallback()
    }
    
    func pushFoward() {
        timer.invalidate()
        navigationController?.pushViewController(WelcomeVC(), animated: true)
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        timer.invalidate()
        setTimer()
        timerCallback()
    }
}

extension HelpVC: CLLocationManagerDelegate {}

