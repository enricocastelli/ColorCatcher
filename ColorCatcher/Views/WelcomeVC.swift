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

    @IBOutlet weak var firstStack: UIStackView!
    @IBOutlet weak var secondStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let touch = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(touch)
        firstStack.transform = CGAffineTransform(scaleX: 0, y: 0)
        secondStack.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewTapped()
    }
    
    @objc func viewTapped() {
        reset()
    }
    
    func reset() {
        UIView.animate(withDuration: 0.2, animations: {
            self.firstStack.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.secondStack.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.discoveryButton.alpha = 1
            self.quickGameButton.alpha = 1
        }) { (done) in
            self.firstStack.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.secondStack.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
    }
    
    @IBAction func raceTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.firstStack.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.quickGameButton.alpha = 0
        }) { (done) in }
        //        showTimePopup()
    }
    
    @IBAction func DiscoveryTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.secondStack.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.discoveryButton.alpha = 0
        }) { (done) in }
    }
    
    @IBAction func albumTapped(_ sender: Any) {
        ColorManager.shared.fetchColors(success: {
            self.pushToCollection()
        }) {
            self.showGeneralError()
        }
    }
    
    @IBAction func netTapped(_ sender: Any) {
        ColorManager.shared.fetchColors(success: {
            self.pushToDiscoveryMode()
        }) {
            self.showGeneralError()
        }
    }
    
    @IBAction func infiniteTapped(_ sender: Any) {
        let gameVC = GameVC()
        navigationController?.show(gameVC, sender: nil)
    }
    
    @IBAction func timeTapped(_ sender: Any) {
        let gameVC = GameTimeVC()
        navigationController?.show(gameVC, sender: nil)
    }
    
    
    func didDismissPopup() {}
    
    
    func pushToCollection() {
        let collectionVC = ColorCollectionVC()
        navigationController?.show(collectionVC, sender: nil)
    }
    
    func pushToDiscoveryMode() {
        let gameVC = GameDiscoveryVC()
        navigationController?.show(gameVC, sender: nil)
    }
}
