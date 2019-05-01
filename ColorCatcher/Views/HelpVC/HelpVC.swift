//
//  HelpVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 30/04/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class HelpVC: ColorController {

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var continueButton: UIButton!
    
    var model: HelpModel
    var continuation: (()->Void)

    
    init(_ model: HelpModel, continuation: @escaping() ->()) {
        self.model = model
        self.continuation = continuation
        super.init(nibName: String(describing: HelpVC.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = model.mainText()
        image.image = model.image()
        continueButton.setTitle(model.buttonText(), for: .normal)
        setButton(continueButton)
        image.tintColor = UIColor.lightGray
    }
    
    func setButton(_ button: UIButton) {
        button.layer.cornerRadius = 20
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        self.continuation()
        self.dismiss(animated: true) {}
    }
    
    override func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


enum HelpModel {
    
    case race
    case discovery
    case multi
    case help
    
    func mainText() -> String {
        switch self {
        case .race:
            return "Welcome to race mode"
        case .discovery:
            return "Welcome to discovery mode"
        case .multi:
            return "Welcome to race mode"
        case .help:
            return "Welcome to race mode"
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .race:
            return UIImage(named: "time")
        case .discovery:
            return UIImage(named: "time")
        case .multi:
            return UIImage(named: "time")
        case .help:
            return UIImage(named: "time")
        }
    }
    
    func buttonText() -> String {
        switch self {
        case .race:
            return "Ok let's go!"
        case .discovery:
            return "Ok let's go!"
        case .multi:
            return "Ok let's go!"
        case .help:
            return "Ok let's go!"
        }
    }
}
