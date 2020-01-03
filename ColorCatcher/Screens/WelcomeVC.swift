//
//  WelcomeVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 25/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController, PopupProvider, StoreProvider, AnalyticsProvider {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var quickGameButton: BouncyButton!
    @IBOutlet weak var discoveryButton: BouncyButton!
    @IBOutlet var multiButton: BouncyButton!
    @IBOutlet var buttonsStackView: UIStackView!
    @IBOutlet var welcomeAnimationView: WelcomeAnimationView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsStackView.spacing = Device.isSE() ? 16 : 32
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setView()
        self.view.layoutIfNeeded()
        guard isWelcomeAnimationOn() else {
            self.view.layoutIfNeeded()
            welcomeAnimationView.addChameleon(false)
            return }
        welcomeAnimationView.startWelcomeAnimation()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        quickGameButton.stop()
        discoveryButton.stop()
        multiButton.stop()
        welcomeAnimationView.removeAllAnimations()
    }
    
    func setView() {
        quickGameButton.set(0)
        discoveryButton.set(0.2)
        multiButton.set(0.4)
    }
    
    func test() {
        let test = EyeProximityTestVC()
        self.navigationController?.show(test, sender: nil)
    }

    @IBAction func raceTapped(_ sender: UIButton) {
        logEvent(.RaceModeTapped)
        navigationController?.pushViewController(GameTimeVC(), animated: true)
    }
    
    @IBAction func DiscoveryTapped(_ sender: UIButton) {
        logEvent(.DiscoveryModeTapped)
        goToDiscovery()
    }
    
    func goToDiscovery() {
        showLoading()
        ColorManager.shared.fetchColors(success: {
            self.stopLoading()
            self.pushToDiscoveryMode()
        }) {
            self.showGeneralError()
        }
    }
    
    @IBAction func multiTapped(_ sender: UIButton) {
//        test()
        logEvent(.MultiplayerTapped)
        let multiVC = MultiplayerVC()
        navigationController?.show(multiVC, sender: nil)
    }

    @IBAction func collectionTapped(_ sender: UIButton) {
        showLoading()
        logEvent(.CollectionTapped)
        ColorManager.shared.fetchColors(success: {
            self.stopLoading()
            self.pushToCollectionMode()
        }) {
            self.showGeneralError()
        }
    }
    
    @IBAction func settingsTapped(_ sender: UIButton) {
        logEvent(.SettingsTapped)
        navigationController?.pushViewController(SettingsVC(), animated: true)
    }
    
    private func pushToCollectionMode() {
        navigationController?.pushViewController(ColorCollectionVC(), animated: true)
    }
    
    private func pushToDiscoveryMode() {
        let gameVC = GameDiscoveryVC()
        navigationController?.pushViewController(gameVC, animated: true)
    }
}
