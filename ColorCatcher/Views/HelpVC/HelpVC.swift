//
//  HelpVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 30/04/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit
import AVFoundation // for Authorization on using camera

fileprivate let texts: [String] = ["You will be given a color to find and catch",
                                          "Look for that color around you...",
                                          "And point your phone on it!",
                                          "",
                                          "Please enable camera access and location"]

class HelpVC: UIViewController, PopupProvider {
    
    @IBOutlet weak var continueButton: BouncyButton!
    @IBOutlet weak var titleLabel: TimerLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.changeText("Welcome to ColorCatcher!")
        continueButton.setTitle("Skip Intro", for: .normal)
        continueButton.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addPhoneView()
        let _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in self.titleLabel.start(texts) }
        let _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (_) in self.addAppleImage() }
        let _ = Timer.scheduledTimer(withTimeInterval: 11, repeats: false) { (_) in
            var model = PopupModel(titleString: "Collect all colors and find out cool facts about them you would never imagined", message: "")
            model.autoremoveTime = 3
            self.showPopup(model)
        }
        let _ = Timer.scheduledTimer(withTimeInterval: 13.5, repeats: false) { (_) in
            self.continueButton.set(0.5)
            self.animateChameleon()
        }
        let _ = Timer.scheduledTimer(withTimeInterval: 15, repeats: false) { (_) in self.askPermissions() }
    }

    func addPhoneView() {
        let width = UIScreen.main.bounds.width
        let phoneFrame = CGRect(x: width, y: 0, width: width, height: width)
        let phoneView = PhoneTourView(frame: phoneFrame)
        phoneView.center.y = self.view.center.y/0.9
        view.addSubview(phoneView)
        phoneView.startAnimation()
    }
    
    func addAppleImage() {
        let width = UIScreen.main.bounds.width
        let appleFrame = CGRect(x: width, y: -width, width: width, height: width)
        self.view.insertSubview(AppleImageView(appleFrame, .Green, 0.7), at: 0)
        self.view.insertSubview(AppleImageView(appleFrame, .Yellow, 0.5), at: 0)
        self.view.insertSubview(AppleImageView(appleFrame, .Red, 0.6), at: 0)
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
    
    func askPermissions() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                let _ = LocationManager.shared
            })
        }
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        navigationController?.show(WelcomeVC(), sender: nil)
        close()
    }
    
    func close() {
        CaptureManager.shared.stopSession()
        self.dismiss(animated: true, completion: nil)
    }
}


