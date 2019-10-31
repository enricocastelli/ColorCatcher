//
//  Common.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 22/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit


extension UIImage {
    
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
    
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIColor {
    
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }

    static func generateRandom() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 100 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.3 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.3 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    func getHue() -> ColorHue? {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: nil) {
            return ColorHue(hue: h, saturation: s, brightness: b)
        }
        return nil
    }
    
    // create a similar color to the one passed (random values)
    func variateColor() -> UIColor {
        guard let hue = self.getHue() else {
            return self
        }
        let randomHue = 0.02 - CGFloat(arc4random_uniform(30))/1000
        let randomSat = 0.02 - CGFloat(arc4random_uniform(50))/1000
        return UIColor(hue: hue.hue + randomHue, saturation: hue.saturation + randomSat, brightness: hue.brightness, alpha: 1)
    }
    
    static var CCpinky = UIColor(red: 214/255, green: 135/255, blue: 190/255, alpha: 1)
    static var CCAqua = UIColor(red: 135/255, green: 225/255, blue: 223/255, alpha: 1)
    static var CCYellow = UIColor(red: 255/255, green: 236/255, blue: 145/255, alpha: 1)
    static var CCGreen = UIColor(red: 71/255, green: 201/255, blue: 60/255, alpha: 1)
    static var CCCoral = UIColor(red: 255/255, green: 60/255, blue: 60/255, alpha: 1)
    static var CCViola = UIColor(red: 182/255, green: 62/255, blue: 255/255, alpha: 1)
    static var CCGreenlight = UIColor(red: 214/255, green: 255/255, blue: 186/255, alpha: 1)
    static var CCWater = UIColor(red: 73/255, green: 136/255, blue: 255/255, alpha: 1)

    static func generateCCRandom() -> UIColor {
        let arr = [UIColor.CCpinky,
                   UIColor.CCAqua,
                   UIColor.CCYellow,
                   UIColor.CCGreen,
                   UIColor.CCCoral,
                   UIColor.CCGreenlight,
                   UIColor.CCViola,
                   UIColor.CCWater]
        return arr.randomElement()!
    }
    
    static func generatePopupRandom() -> UIColor {
        let array = [UIColor(hex: "9BB7D4"),
                     UIColor(hex: "C74375"),
                     UIColor(hex: "BF1932"),
                     UIColor(hex: "7BC4C4"),
                     UIColor(hex: "E2583E"),
                     UIColor(hex: "DECDBE"),
                     UIColor(hex: "9B1B30"),
                     UIColor(hex: "5A5B9F"),
                     UIColor(hex: "F0C05A"),
                     UIColor(hex: "F0C05A"),
                     UIColor(hex: "45B5AA"),
                     UIColor(hex: "DD4124"),
                     UIColor(hex: "D94F70"),
                     UIColor(hex: "009473"),
                     UIColor(hex: "B163A3"),
                     UIColor(hex: "955251"),
                     UIColor(hex: "F7CAC9"),
                     UIColor(hex: "92A8D1"),
                     UIColor(hex: "88B04B"),
                     UIColor(hex: "5F4B8B"),
                     UIColor(hex: "FF6F61"),
                     UIColor(hex: "00008b"),
        ]
        let random = array.randomElement()!
        return random
    }
    
}

extension CGFloat {
    
    var colorString: String {
        return String(format: "%.0f", (self*255))
    }
    
    var string: String {
        return String(format: "%.0f", (self))
    }
    
    var stringPercentage: String {
        return "\(String(format: "%.0f", (self))) %"
    }
}

extension UINavigationController {
    
    func insertHelpTransition(_ duration: Double) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.view.layer.add(transition, forKey: "pushIn")
    }
    
    func removeHelpTransition(_ duration: Double) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.layer.add(transition, forKey: "pushOut")
    }
}

extension UILabel {
    
    func changeText(_ newText : String) {
        let anim = CATransition()
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        anim.type = CATransitionType.push
        anim.duration = 0.4
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


class RoundView: UIView {
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.height/2
    }
}

struct ColorHue {
    var hue: CGFloat
    var saturation: CGFloat
    var brightness: CGFloat

}

func Logger(_ error: String) {
    print("🎨⚠️ - \(error)")
}

func Logger(_ error: Error) {
    print("🎨⚠️ - \((error as? NSError)?.description ?? "")")
}

func prettyPrint(data: Data?) {
    print(String(data: data!, encoding: String.Encoding.utf8) ?? "No Data")
}

func yesOrNo(_ options: UInt32) -> Bool {
    return arc4random_uniform(options) == 0
}

extension UIView {
    
    /// add view subview that ocuppy the whole view.
    func addContentView(_ contentView: UIView) {
        let containerView = self
        contentView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contentView)
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
    
}

extension UIViewController {


    func showLoading() {
        self.view.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        self.view.isUserInteractionEnabled = true
    }

    
}

extension Date {
    
    var string : String {
        let form = DateFormatter()
        form.dateFormat = "dd MMMM yyyy"
        return form.string(from: self)
    }
    
}
