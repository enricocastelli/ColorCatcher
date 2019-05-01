//
//  HelpVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 30/04/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class HelpVC: UIViewController {

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var continueButton: UIButton!
    
    var model: HelpModel
    
    init(_ model: HelpModel) {
        self.model = model
        super.init(nibName: String(describing: HelpVC.self), bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.text = model.mainText()
        image.image = model.image()
        continueButton.setTitle(model.buttonText(), for: .normal)
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
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
            return "Go!"
        case .discovery:
            return "Go!"
        case .multi:
            return "Go!"
        case .help:
            return "Go!"
        }
    }
}
