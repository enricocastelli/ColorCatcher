

import UIKit

fileprivate enum PopupDirection {
    case left
    case center
    case right
}

protocol PopupDelegate: class {
    func didDismissPopup()
}

class PopupVC: UIViewController {
    
    var titleString: String
    var message: String
    var button: String
    var shouldAutoRemove: Bool = false
    weak var delegate: PopupDelegate?

    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var masterView: UIView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    // CONSTRAINTS
    @IBOutlet weak var descLeading: NSLayoutConstraint!
    @IBOutlet weak var descTrailing: NSLayoutConstraint!
    @IBOutlet weak var descBottom: NSLayoutConstraint!
    @IBOutlet weak var descTop: NSLayoutConstraint!
    
    
    init(titleString: String, message: String, button: String) {
        self.titleString = titleString
        self.message = message
        self.button = button
        super.init(nibName: String(describing: PopupVC.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        self.view.addGestureRecognizer(tap)
        titleLabel.text = titleString
        textView.text = "\(message)\n"
        addBlurEffect()
        preAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showColors()
        if shouldAutoRemove {
            let _ = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (_) in
                self.tappedView()
            }
        } else {
            animateFadeIn()
        }
    }
    
    @objc func tappedView() {
        self.removePopup {
            self.delegate?.didDismissPopup()
            self.dismiss(animated: false, completion: {
            })
        }
    }
    
    func preAnimation() {
        descView.alpha = 0
        coverView.alpha = 0
        descTop.constant = 100
        descBottom.constant = -100
    }
    
    func removePopup(done: @escaping () -> ()) {
        let opAnim = CABasicAnimation(keyPath: "opacity")
        opAnim.duration = 0.3
        opAnim.fromValue = 1
        opAnim.toValue = 0
        opAnim.isRemovedOnCompletion = false
        masterView.layer.add(opAnim, forKey: "opacity")
        masterView.layer.opacity = 0

        if !shouldAutoRemove {
            coverView.layer.add(opAnim, forKey: "opacity")
            descView.layer.add(opAnim, forKey: "opacity")
            coverView.layer.opacity = 0
            descView.layer.opacity = 0
        }

        let _ = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (_) in
            done()
        }
    }
    
    func showColors() {
        addColorLayer(.left)
        let _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { (_) in
            self.addColorLayer(.right)
        }
        let _ = Timer.scheduledTimer(withTimeInterval: 0.14, repeats: false) { (_) in
            self.addColorLayer(.center)
        }
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = coverView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coverView.addSubview(blurEffectView)
    }
    
    func animateFadeIn() {
        descTop.constant = -8
        descBottom.constant = 0
        UIView.animate(withDuration: 0.7, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.coverView.alpha = 1
            self.descView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (done) in
        }
    }
    
    private func addColorLayer(_ direction: PopupDirection) {
        let position = positionForDirection(direction)
        let totalSize = UInt32(UIScreen.main.bounds.width)
        let randomSize: CGFloat = CGFloat(arc4random_uniform(totalSize/10) + totalSize/4)
        
        // initially the bezier is very small, to get enlarged with animation
        let noneRect = CGRect(x: position.x, y: position.y + randomSize, width: 0, height: 0)
        let initialBezier = UIBezierPath(ovalIn: noneRect)
       
        // actual bezier size
        let rect = CGRect(x: position.x, y: position.y, width: randomSize, height: randomSize)
        let bezier = UIBezierPath(ovalIn: rect)
        
        let mainColor = randomAnimationColor()

        let shapeLayer = newShapeLayer(mainColor, initialPath: initialBezier, finalPath: bezier)
        masterView.layer.addSublayer(shapeLayer)
        animateLayerOpacity(shapeLayer)
        
        // creating 77 small drops with different alpha
        for _ in 0...77 {
            addSmall(shapeLayer, color: mainColor, position: position, circleWidth: UInt32(randomSize))
        }
    }
    
    func addSmall(_ masterLayer: CAShapeLayer, color: UIColor, position: CGPoint, circleWidth: UInt32) {
        let width: CGFloat = CGFloat(arc4random_uniform(circleWidth/2) + 10)
        let randomX: CGFloat = CGFloat(arc4random_uniform(circleWidth)) + position.x
        let randomY: CGFloat = CGFloat(arc4random_uniform(circleWidth)) + position.y
        
        let noneRect = CGRect(x: randomX + (width/2), y: randomY + (width/2), width: 0, height: 0)
        let initialBezier = UIBezierPath(ovalIn: noneRect)
        
        let rect = CGRect(x: randomX, y: randomY, width: width, height: width)
        let finalBezier = UIBezierPath(ovalIn: rect)
        
        let smallLayer = newDropLayer(color, initialPath: initialBezier, finalPath: finalBezier)
        masterLayer.addSublayer(smallLayer)
    }
    
    private func positionForDirection(_ direction: PopupDirection) -> CGPoint {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        switch direction {
        case .left:
            return CGPoint(x: width/6, y: shouldAutoRemove ? height/2.5 : height/5)
        case .center:
            return CGPoint(x: width/3.5, y: shouldAutoRemove ? height/2.1 : height/4)
        case .right:
            return CGPoint(x: width/2, y: shouldAutoRemove ? height/2.6 : height/5.2)
        }
    }
    
    private func newShapeLayer(_ color: UIColor, initialPath: UIBezierPath, finalPath: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = initialPath.cgPath
        shapeLayer.fillColor = color.cgColor
        shapeLayer.opacity = 0
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.2
        animation.fromValue = initialPath.cgPath
        animation.toValue = finalPath.cgPath
        shapeLayer.add(animation, forKey: "updatePath")
        shapeLayer.path = finalPath.cgPath
        return shapeLayer
    }
    
    private func animateLayerOpacity(_ shapeLayer: CAShapeLayer) {
        let opAnim = CABasicAnimation(keyPath: "opacity")
        opAnim.duration = 0.3
        opAnim.fromValue = 0
        opAnim.toValue = 1
        shapeLayer.add(opAnim, forKey: "opacity")
        shapeLayer.opacity = 1
    }
    
    private func newDropLayer(_ color: UIColor, initialPath: UIBezierPath, finalPath: UIBezierPath) -> CAShapeLayer {
        let isSlow = arc4random_uniform(20) == 5
        let randomAlpha: CGFloat = isSlow ? 1 : (CGFloat(arc4random_uniform(10)) + 2)/10
        let duration: Double =  isSlow ? Double(arc4random_uniform(40) + 30)/10 : Double(arc4random_uniform(3) + 2)/10
        
        let dropLayer = CAShapeLayer()
        dropLayer.path = initialPath.cgPath
        dropLayer.fillColor = color.withAlphaComponent(randomAlpha).cgColor
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.fromValue = initialPath.cgPath
        animation.toValue = finalPath.cgPath
        animation.timingFunction = isSlow ? CAMediaTimingFunction(name: .easeOut) : CAMediaTimingFunction(name: .easeInEaseOut)
        dropLayer.add(animation, forKey: "updatePath")
        dropLayer.path = finalPath.cgPath
        return dropLayer
    }
    
    private func randomAnimationColor() -> UIColor {
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
