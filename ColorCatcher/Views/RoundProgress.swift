//
//  RoundProgress.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 12/03/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class RoundProgress: UIView {
    
    var path = UIBezierPath()
    var shapeLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()
    var proximityLabel = UILabel()
    var progressColor = UIColor.red
    {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
            proximityLabel.textColor = progressColor
        }
    }
    
    override func layoutSubviews() {
        createCirclePath()
        createLayers()
        setLabel()
        self.layer.cornerRadius = self.frame.width/2
    }
    
    private func createCirclePath() {
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y)
        path.addArc(withCenter: center, radius: x/CGFloat(1.3), startAngle: CGFloat(0), endAngle: CGFloat(6.28), clockwise: true)
        path.close()
    }
    
    private func createLayers() {
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.clear.cgColor
        progressLayer.path = path.cgPath
        progressLayer.lineWidth = 7
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.fillColor = nil
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.strokeEnd = 0
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
    }
    
    func setLabel() {
        proximityLabel.frame = self.bounds
        proximityLabel.textColor = progressColor
        proximityLabel.textAlignment = .center
        self.addSubview(proximityLabel)
    }
    
    func updateProgress(_ progress: CGFloat) {
        progressLayer.strokeEnd = progress
        guard progress < 1 else { return }
        proximityLabel.text = (progress*100).stringPercentage
    }
}
