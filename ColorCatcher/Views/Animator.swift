//
//  Animator.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 07/09/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

open class Animator: UIImageView {
    
    private var images: [UIImage]
    private var frameTime: Double
    private var timer = Timer()
    private var imageCount = 0
    private var shouldStop = false
    private var completionStop: ()->()? = {}
    
    public init(_ frame: CGRect, images: [UIImage], frameTime: Double) {
        self.images = images
        self.frameTime = frameTime
        super.init(frame: frame)
        addObserver()
        setup()
    }
    
    public init(_ frame: CGRect, imageName: String, count: Int, frameTime: Double) {
        self.images = getImages(imageName, count)
        self.frameTime = frameTime
        super.init(frame: frame)
        addObserver()
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(self.shouldStopTimer),
                                       name: .shouldStopTimer,
                                       object: nil)
    }
    
    func setup() {} // overriden
    
    private func timerCall() {
        if imageCount >= images.count {
            imageCount = 0
        }
        self.image = images[imageCount]
        if imageCount == 0 && shouldStop {
            timer.invalidate()
            completionStop()
        }
        imageCount += 1
    }
    
    open func start(_ frameTime: Double? = nil) {
        shouldStop = false
        timer = Timer.scheduledTimer(withTimeInterval: frameTime ?? self.frameTime, repeats: true, block: { (timer) in
            self.timerCall()
        })
        timer.fire()
    }
    
    open func stop() {
        timer.invalidate()
    }
    
    open func stopAtFirst(completion: @escaping()->()) {
        shouldStop = true
        self.completionStop = completion
    }
    
    open func stopAtFirst() {
        shouldStop = true
    }
    
    @objc func shouldStopTimer() {
        stop()
        removeFromSuperview()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

fileprivate func getImages(_ imageName: String,_ count: Int) -> [UIImage] {
    var arr = [UIImage]()
    for ind in 0...count - 1 {
        if let img = UIImage(named: "\(imageName)\(ind)") {
            arr.append(img)
        }
    }
    return arr
}


class Animation: NSObject, CAAnimationDelegate {
    
    let completion: (()->Void)
    
    init(animation: CAAnimation, object: CALayer, completion: @escaping()->()) {
        self.completion = completion
        super.init()
        animation.delegate = self
        object.add(animation, forKey: "")
    }
    
    func load() {}
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completion()
    }
    
}
