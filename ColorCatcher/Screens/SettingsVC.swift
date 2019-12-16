//
//  SettingsVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 04/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class SettingsVC: ColorController, PopupProvider {

    @IBOutlet weak var shareButton: BouncyButton!
    @IBOutlet weak var tourButton: BouncyButton!
    @IBOutlet weak var creditsButton: BouncyButton!
    @IBOutlet var buttonsStackView: UIStackView!
    
    @IBOutlet var optionsStackView: UIStackView!

    @IBOutlet weak var animationLabel: UILabel!
    @IBOutlet weak var animationSwitch: UISwitch!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelSegment: UISegmentedControl!

    @IBOutlet weak var multiplayerLabel: UILabel!
    @IBOutlet weak var multiplayerField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton(shareButton, 0)
        setButton(tourButton, 0.2)
        setButton(creditsButton, 0.4)
        animationLabel.text = "Welcome animation"
        animationSwitch.isOn = isWelcomeAnimationOn()
        multiplayerLabel.text = "Multiplayer name"
        multiplayerField.placeholder = getMultiplayerName()
        levelLabel.text = "Level"
        levelSegment.selectedSegmentIndex = getLevel()
        multiplayerField.delegate = self
        buttonsStackView.spacing = Device.isSE() ? 16 : 32
    }
    
    func setButton(_ button: BouncyButton,_ delay: Double) {
        button.backgroundColor = UIColor.generatePopupRandom()
        button.set(delay)
    }
    
    @IBAction func animationSwitchTapped(_ sender: UISwitch) {
        animationSwitch.isOn ?
            logEvent(.WelcomeAnimationTurnedOn) :
            logEvent(.WelcomeAnimationTurnedOff)
        setWelcomeAnimation(animationSwitch.isOn)
    }
    
    @IBAction func levelSegmentTapped(_ sender: UISegmentedControl) {
        setLevel(sender.selectedSegmentIndex)
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        //todo
        logEvent(.ShareTapped)
        let vc = UIActivityViewController(activityItems: ["Color Catcher  https:www.google.com"], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tourTapped(_ sender: UIButton) {
        logEvent(.WatchTourAgainTapped)
        navigationController?.pushViewController(HelpVC(), animated: true)
    }
    
    @IBAction func creditsTapped(_ sender: UIButton) {
        logEvent(.CreditsTapped)
        var model = PopupModel(titleString: "Credits!", message: "🍏 Many thanks to the sweet and talented Marie Benoist, for helping me out with the design of the app. \n\n🍅Adamo for being tester!\n\n🍊 Christopher Jones for letting me use his chameleon animation.\n\n")
        model.subtitleString = "This app was made with ❤️ by Enrico Castelli"
        model.color = UIColor.generateCCRandom()
        model.opacity = 0.5
        showPopup(model)
    }
}

extension SettingsVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.getValidText() else {
            return false
        }
        setMultiplayerName(text)
        logEvent(.MultiplayerNameChanged)
        return true
    }
}
