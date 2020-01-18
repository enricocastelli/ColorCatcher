//
//  Extensions.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 29/10/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

extension UIView {
    
    /// add view subview that ocuppy the whole view.
    func addContentView(_ contentView: UIView, _ atIndex: Int? = nil) {
        let containerView = self
        contentView.translatesAutoresizingMaskIntoConstraints = false
        if let atIndex = atIndex {
            containerView.insertSubview(contentView, at: atIndex)
        } else {
            containerView.addSubview(contentView)
        }
        NSLayoutConstraint.init(item: contentView,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: containerView,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: contentView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: containerView,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: contentView,
                                attribute: .right,
                                relatedBy: .equal,
                                toItem: containerView,
                                attribute: .right,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: contentView,
                                attribute: .left,
                                relatedBy: .equal,
                                toItem: containerView,
                                attribute: .left,
                                multiplier: 1,
                                constant: 0).isActive = true
    }
    
    func clear() {
        for sub in subviews {
            sub.removeFromSuperview()
        }
    }
}

extension UIStackView {
    
    func add(_ views: [UIView]) {
        for view in views {
            self.insertArrangedSubview(view, at: 0)
        }
    }
}

extension UIViewController {
    
    
    func showLoading() {
        self.view.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        self.view.isUserInteractionEnabled = true
    }
}

extension UILabel {
   
    func changeText(_ newText: String, _ type: CATransitionType? = nil, _ duration: Double? = nil) {
        let anim = CATransition()
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        anim.type = type ?? .push
        anim.duration = duration ?? 0.55
        if self.text != newText {
            self.layer.add(anim, forKey: "change")
            self.text = newText
        }
    }
}


extension UIFont {
    
    public class func mediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "BrandonGrotesque-Medium", size: size)!
    }
    
    public class func regularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "BrandonGrotesque-Regular", size: size)!
    }
    
    public class func boldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "BrandonGrotesque-Bold", size: size)!
    }
    
    public class func ultraBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "BrandonGrotesque-Black", size: size)!
    }
}

extension CGFloat {
    
    var stringPercentage: String {
        return "\(String(format: "%.0f", (self))) %"
    }
}

extension Date {
    
    var string : String {
        let form = DateFormatter()
        form.dateFormat = "dd MMMM yyyy"
        return form.string(from: self)
    }
    
}

extension Notification.Name {
    static let shouldStopTimer = Notification.Name(rawValue: "shouldStopTimer")
    static let locationStatusDidChange = Notification.Name(rawValue: "locationStatusDidChange")
}

extension CALayer {
    
    func fadeOut(_ duration: Double) {
        let opAnim = CABasicAnimation(keyPath: "opacity")
        opAnim.duration = 0.3
        opAnim.fromValue = 1
        opAnim.toValue = 0
        opAnim.isRemovedOnCompletion = false
        add(opAnim, forKey: "opacity")
        opacity = 0
    }
    
    func fadeOutWithDelay(_ duration: Double, delay: TimeInterval) {
        let opAnim = CABasicAnimation(keyPath: "opacity")
        opAnim.duration = duration
        opAnim.fromValue = 1
        opAnim.beginTime = CACurrentMediaTime() + delay
        opAnim.toValue = 0
        opAnim.isRemovedOnCompletion = false
        add(opAnim, forKey: "opacity")
        opacity = 0
    }
    
}

extension String {
    
    var multiplayerName: String {
        let nameString = self.replacingOccurrences(of: "iPhone", with: "").replacingOccurrences(of: "'s", with: "").replacingOccurrences(of: "di", with: "").replacingOccurrences(of: " ", with: "")
        guard nameString != "" && nameString != " " && nameString.count < 60 else { return "iPhone" }
        return nameString
    }
}

extension UITextField {
    
    func getValidText() -> String? {
        guard text != "", let text = text else {
            return nil
        }
        return text
    }
}

extension Data {
    
    func prettyPrint() {
        print(utf8() ?? "No Data")
    }
    
    func utf8() -> String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
}
