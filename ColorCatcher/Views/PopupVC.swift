
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
    var color: UIColor?
    var shouldAutoRemove: Bool = false
    weak var delegate: PopupDelegate?
    var masterLayer = CALayer()
    var drops = [DropLayer]()

    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    // CONSTRAINTS
    @IBOutlet weak var descLeading: NSLayoutConstraint!
    @IBOutlet weak var descTrailing: NSLayoutConstraint!
    @IBOutlet weak var descBottom: NSLayoutConstraint!
    @IBOutlet weak var descTop: NSLayoutConstraint!
    
    
    init(titleString: String, message: String, button: String, color: UIColor? = nil) {
        self.titleString = titleString
        self.message = message
        self.button = button
        self.color = color
        super.init(nibName: String(describing: PopupVC.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapRecognizer()
        titleLabel.text = titleString
        textView.text = "\(message)\n"
        if titleString == "" {
            closeButton.isHidden = true
        }
        addBlurEffect()
        preAnimation()
        masterLayer.opacity = 0.8
        view.layer.insertSublayer(masterLayer, above: coverView.layer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addDrops()
        if shouldAutoRemove {
            let _ = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (_) in
                self.tappedView()
            }
        } else {
            animateFadeIn()
        }
    }
    
    private func addTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tappedView() {
        self.removePopup {
            self.delegate?.didDismissPopup()
            self.dismiss(animated: false, completion: {
            })
        }
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        tappedView()
    }
    
    func preAnimation() {
        descView.alpha = 0
        coverView.alpha = 0
        descTop.constant = 700
        descBottom.constant = -700
    }
    
    
    func addDrops() {
        addDropSet()
        let _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { (_) in
            self.addDropSet()
        }
        let _ = Timer.scheduledTimer(withTimeInterval: 0.14, repeats: false) { (_) in
            self.addDropSet()
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
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseInOut, animations: {
            self.descTop.constant = -8
            self.descBottom.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.7, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.coverView.alpha = 1
            self.descView.alpha = 1
        }) { (done) in
        }
    }
    
    private func addDropSet() {
        // creating 27 small drops with different alpha
        for _ in 0...26 {
            let layer = DropLayer(color ?? UIColor.generatePopupRandom())
            drops.append(layer)
            masterLayer.addSublayer(layer)
        }
    }
    
    func removePopup(done: @escaping () -> ()) {
        closeButton.layer.fadeOut(0.3)
        if !shouldAutoRemove {
            coverView.layer.fadeOut(0.3)
            descView.layer.fadeOut(0.3)
        }
        for drop in drops {
            drop.fade()
        }
        let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
            done()
        }
    }
}
