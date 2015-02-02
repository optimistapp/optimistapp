//
//  SunBar.swift
//  Optimist
//
//  Created by Jacob Johannesen on 1/31/15.
//  Copyright (c) 2015 MonsterCreate. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

public class SunBar: UIView
{
    let STATUS_BAR_PADDING: CGFloat = 8.0
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor(netHex:0xffb242)
        
        let outerRingImage = UIImage(named: "outerRing")
        let outerRingImageView = UIImageView(image: outerRingImage)
        outerRingImageView.frame = CGRect(x: self.frame.width / 2 - outerRingImageView.frame.width / 2, y: self.frame.height / 2 - outerRingImageView.frame.height / 2 + STATUS_BAR_PADDING, width: outerRingImageView.frame.width, height: outerRingImageView.frame.height)
        self.addSubview(outerRingImageView)
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 15
        rotateAnimation.repeatCount = Float.infinity
        rotateAnimation.delegate = self
        outerRingImageView.layer.addAnimation(rotateAnimation, forKey: nil)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}