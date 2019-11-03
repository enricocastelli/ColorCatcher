
import UIKit

class BouncyButton: UIButton {

    var timer = Timer()
    
    func set(_ delay: Double) {
        setup()
        let _ = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (_) in
            self.startTimer()
        }
    }
    
    func setup() {
        layer.cornerRadius = 20
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
    }
    
    func stop() {
        timer.invalidate()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (_) in
            self.animate()
        })
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.4, animations: {
            self.transform = CGAffineTransform(scaleX: 1.07, y: 1.07)
        }) { (_) in
            UIView.animate(withDuration: 0.4, animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
}
