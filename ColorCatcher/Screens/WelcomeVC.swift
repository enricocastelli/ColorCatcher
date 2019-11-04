//
//  WelcomeVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 25/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController, PopupProvider, StoreProvider, WelcomeAnimator {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var quickGameButton: BouncyButton!
    @IBOutlet weak var discoveryButton: BouncyButton!
    @IBOutlet var multiButton: BouncyButton!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startWelcomeAnimation()
        setView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        quickGameButton.stop()
        discoveryButton.stop()
        multiButton.stop()
        removeAllAnimations()
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
        pushToRaceMode()
    }
    
    @IBAction func DiscoveryTapped(_ sender: UIButton) {
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
        let multiVC = MultiplayerVC()
        navigationController?.show(multiVC, sender: nil)
    }

    @IBAction func collectionTapped(_ sender: UIButton) {
        showLoading()
        ColorManager.shared.fetchColors(success: {
            self.stopLoading()
            self.pushToCollectionMode()
        }) {
            self.showGeneralError()
        }
    }
    
    private func pushToRaceMode() {
        let gameVC = GameTimeVC()
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    private func pushToCollectionMode() {
        let collection = ColorCollectionVC()
        navigationController?.pushViewController(collection, animated: true)
    }
    
    private func pushToDiscoveryMode() {
        let gameVC = GameDiscoveryVC()
        navigationController?.pushViewController(gameVC, animated: true)
    }
}