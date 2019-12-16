//
//  ChameleonView.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 31/10/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

enum ChameleonColor: String {
    case Blue, Brown, Purple, Aqua, Salmon, Red
    
    static func random() -> ChameleonColor {
        return [.Blue, .Brown, .Purple, .Aqua, .Salmon, .Red].randomElement()!
    }
    
    func color() -> UIColor {
        switch self {
        case .Blue: return UIColor(hex: "7FB6B9")
        case .Brown: return UIColor(hex: "9D8B3D")
        case .Purple: return UIColor(hex: "b091ff")
        case .Aqua: return UIColor(hex: "acaee6")
        case .Salmon: return UIColor(hex: "faa289")
        case .Red: return UIColor(hex: "fc6b5d")
        }
    }
}

// chameleon image original ratio: ratio 325:125

fileprivate var getChameleonHeight: CGFloat = {
    return UIScreen.main.bounds.height/10
}()
fileprivate var getChameleonWidth: CGFloat = {
    return UIScreen.main.bounds.height/5.5
}()
fileprivate var getChameleonY: CGFloat = {
    return UIScreen.main.bounds.height/4
}()

class ChameleonView: Animator, AnalyticsProvider {
    
    var wentBackground = false
    
    init() {
        let chameleonHeight = getChameleonHeight
        let chameleonWidth = getChameleonWidth
        let chFrame = CGRect(x: 0, y: 0, width: chameleonWidth, height: chameleonHeight)
        super.init(chFrame, imageName: "chameleon", count: 50, frameTime: 0.05)
    }
    
    init(_ frame: CGRect) {
        let chFrame = frame
        super.init(chFrame, imageName: "chameleon", count: 50, frameTime: 0.05)
    }
    
    override func setup() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    override func shouldStopTimer() {
        wentBackground = true
        stopAtFirst()
    }
    
    func goToStatic() {
        self.image = UIImage(named: "chameleonX")
    }
    
    func changeColor(_ color: ChameleonColor, _ delay: Double? = nil) {
        let _ = Timer.scheduledTimer(withTimeInterval: delay ?? 0, repeats: false) { (_) in
            UIView.transition(with: self,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.image = self.getImage(color)
            },completion: nil)
        }
    }
    
    private func getImage(_ color: ChameleonColor) -> UIImage? {
        return UIImage(named: "chameleon\(color.rawValue)")
    }
    
    @objc private func viewTapped() {
        logEvent(.ChameleonTapped)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(CGRect.zero, imageName: "chameleon", count: 50, frameTime: 0.05)
    }
}
