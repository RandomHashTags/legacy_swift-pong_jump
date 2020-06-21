//
//  UIRing.swift
//  Pong Jump
//
//  Created by Evan Anderson on 6/17/20.
//  Copyright © 2020 Evan Anderson. All rights reserved.
//

import Foundation
import UIKit

class UIRing : UIView {
    
    private var circleLayer:CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
        
        let frameSize:CGSize = frame.size
        let frameWidth:CGFloat = frameSize.width, frameHeight:CGFloat = frameSize.height
        let circlePath:UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: frameWidth/2.0, y: frameHeight/2.0), radius: (frameWidth-10)/2, startAngle: 0.0, endAngle: CGFloat(CGFloat.pi * 2.0), clockwise: true)

        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 5.0
        circleLayer.strokeEnd = 0.0

        layer.addSublayer(circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateCircle(duration: TimeInterval, fromValue: CGFloat, toValue: CGFloat, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        circleLayer.strokeEnd = 1.0
        circleLayer.add(animation, forKey: "animateCircle")
        CATransaction.commit()
    }
    
    internal func getCircleLayer() -> CAShapeLayer {
        return circleLayer
    }
}
