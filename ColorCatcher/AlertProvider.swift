//
//  AlertProvider.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 26/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

protocol AlertProvider {
    
    func showAlert(title : String, message : String, firstButton : String, secondButton : String?, firstCompletion: @escaping () -> (), secondCompletion: (() -> ())?)
    
}

extension AlertProvider where Self: UIViewController {
    
    func showAlert(title : String, message : String, firstButton : String, secondButton : String?, firstCompletion: @escaping () -> (), secondCompletion: (() -> ())?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: firstButton, style: .cancel) { (act) in
                firstCompletion()
            }
            alert.addAction(action)
            if let secondButton = secondButton {
                let action2 = UIAlertAction(title: secondButton, style: .default) { (act) in
                    secondCompletion?()
                }
                alert.addAction(action2)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}
