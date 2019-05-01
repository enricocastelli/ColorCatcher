//
//  WelcomeVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 25/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import Foundation
import UIKit

class WelcomeVC: UIViewController, AlertProvider {
    
    @IBOutlet weak var quickGameButton: UIButton!
    @IBOutlet weak var discoveryButton: UIButton!
    @IBOutlet var multiButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setView() {
        setButton(quickGameButton)
        setButton(discoveryButton)
        setButton(multiButton)
    }
    
    func setButton(_ button: UIView) {
        button.layer.cornerRadius = 20
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
    }
    
    @IBAction func raceTapped(_ sender: UIButton) {
        let gameVC = GameTimeVC()
        navigationController?.show(gameVC, sender: nil)
    }
    
    @IBAction func DiscoveryTapped(_ sender: UIButton) {
        ColorManager.shared.fetchColors(success: {
            self.pushToDiscoveryMode()
        }) {
            self.showGeneralError()
        }
    }
    
    
    @IBAction func multiTapped(_ sender: UIButton) {
        let multiVC = MultiplayerVC()
        navigationController?.show(multiVC, sender: nil)
    }
    
    func didDismissPopup() {}
    
    func pushToDiscoveryMode() {
        let gameVC = GameDiscoveryVC()
        navigationController?.show(gameVC, sender: nil)
    }
}
