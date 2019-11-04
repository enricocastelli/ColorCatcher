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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.backgroundColor = UIColor.generatePopupRandom()
        tourButton.backgroundColor = UIColor.generatePopupRandom()
        creditsButton.backgroundColor = UIColor.generatePopupRandom()
        shareButton.set(0)
        tourButton.set(0.2)
        creditsButton.set(0.4)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        //todo
        let vc = UIActivityViewController(activityItems: ["Color Catcher  https:www.google.com"], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tourTapped(_ sender: UIButton) {
        navigationController?.pushViewController(HelpVC(), animated: true)
    }
    
    @IBAction func creditsTapped(_ sender: UIButton) {
        var model = PopupModel(titleString: "Credits!", message: "🍏 Many thanks to the sweet and talented Marie Benoist, for helping me out with the design of the app.\n\n🍎 Christopher Jones for letting me use his chameleon animation.\n\n🍊 Kassia St Clair for her book \"The Secret Lives of Colors\"")
        model.subtitleString = "This app was made with ❤️ by Enrico Castelli"
        model.color = UIColor.generateCCRandom()
        model.opacity = 0.5
        showPopup(model)
    }


}
