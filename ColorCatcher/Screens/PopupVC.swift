
import UIKit

struct PopupModel {
    let titleString: String
    let message: String
    var subtitleString: String?
    var button: String?
    var color: UIColor?
    var autoremoveTime: Double?
    var opacity: Float?
    var plusOneVisible: Bool = false
    
    init(titleString: String, message: String) {
        self.titleString = titleString
        self.message = message
    }
    
    static func plusOne(_ autoRemove: Double? = nil) -> PopupModel {
        var model = PopupModel(titleString: "", message: "")
        model.autoremoveTime = autoRemove
        model.plusOneVisible = true
        return model
    }
}

@objc protocol PopupDelegate: class {
    @objc optional func didDismissPopup()
}

class PopupVC: UIViewController, DropProvider {
    
    var model: PopupModel
    weak var delegate: PopupDelegate?
    var masterLayer = CALayer()
    var drops = [DropLayer]()
    var stroke: StrokeLayer?

    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var coverView: BlurredView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    // CONSTRAINTS
    @IBOutlet weak var descLeading: NSLayoutConstraint!
    @IBOutlet weak var descTrailing: NSLayoutConstraint!
    @IBOutlet weak var descBottom: NSLayoutConstraint!
    @IBOutlet weak var descTop: NSLayoutConstraint!
    
    
    init(_ model: PopupModel) {
        self.model = model
        super.init(nibName: String(describing: PopupVC.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapRecognizer()
        titleLabel.text = model.titleString
        subtitleLabel.text = model.subtitleString
        textView.text = "\(model.message)\n"
        if model.titleString == "" {
            closeButton.isHidden = true
        }
        preAnimation()
        masterLayer.opacity = model.opacity ?? 0.8
        view.layer.insertSublayer(masterLayer, above: coverView.layer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addDrops()
        addLine()
        animateFadeIn()
        if let autoremoveTime = model.autoremoveTime {
            let _ = Timer.scheduledTimer(withTimeInterval: autoremoveTime, repeats: false) { (_) in
                self.tappedView()
            }
        }
        textView.setContentOffset(.zero, animated: false)
    }
    
    private func addTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tappedView() {
        self.removePopup {
            self.delegate?.didDismissPopup?()
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
        descTop.constant = UIScreen.main.bounds.height
        descBottom.constant = -UIScreen.main.bounds.height
    }
    
    func postAnimation() {
        descTop.constant = -100
        descBottom.constant = 100
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func addDrops() {
        addDrop()
        let _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { (_) in
            self.addDrop()
        }
        let _ = Timer.scheduledTimer(withTimeInterval: 0.14, repeats: false) { (_) in
            self.addDrop()
        }
    }
    
    func addDrop() {
        drops.append(contentsOf: addDropSet(26, color: model.color, masterLayer: masterLayer))
    }
    
    func addLine() {
        guard let color = model.color else { return }
        self.stroke = addStroke(color, masterLayer: masterLayer)
    }

    func animateFadeIn() {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
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
    
    func removePopup(done: @escaping () -> ()) {
        closeButton.layer.fadeOut(0.3)
        postAnimation()
        coverView.layer.fadeOut(0.3)
        descView.layer.fadeOut(0.3)
        stroke?.fade()
        for drop in drops {
            drop.fade()
        }
        let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
            done()
        }
    }
}
