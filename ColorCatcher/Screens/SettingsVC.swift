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
        multiplayerField.text = getMultiplayerName()
        levelLabel.text = "Level"
        setSegmentedControl()
        multiplayerField.delegate = self
        buttonsStackView.spacing = Device.isSE() ? 16 : 32
    }
    
    func setButton(_ button: BouncyButton,_ delay: Double) {
        button.backgroundColor = UIColor.generatePopupRandom()
        button.set(delay)
    }
    
    func setSegmentedControl() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        levelSegment.selectedSegmentIndex = getLevel()
        levelSegment.tintColor = .white
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
        logEvent(.ShareTapped)
        let vc = UIActivityViewController(activityItems: [Service.shared.getAppStoreLink()], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tourTapped(_ sender: UIButton) {
        logEvent(.WatchTourAgainTapped)
        navigationController?.pushViewController(HelpVC(), animated: true)
    }
    
    @IBAction func creditsTapped(_ sender: UIButton) {
        logEvent(.CreditsTapped)
        var model = PopupModel(titleString: "Credits!", message: Service.shared.getCredits())
        model.subtitleString = "This app was made with ❤️ by Enrico Castelli."
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
