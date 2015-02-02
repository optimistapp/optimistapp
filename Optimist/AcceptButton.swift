//
//  AcceptButton.swift
//  Optimist
//
//  Created by Jacob Johannesen on 1/31/15.
//  Copyright (c) 2015 MonsterCreate. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

public class AcceptButton: UIButton
{
    let DEFAULT_HEIGHT: CGFloat = 50.0
    let DEFAULT_BUTTON_OPACITY: CGFloat = 1.0
    let DEFAULT_BUTTON_OPACITY_TAPPED: CGFloat = 0.0
    
    var color: UIColor = UIColor(netHex:0x64bf6b)
    var moodView: MoodView
    
    public init(width: CGFloat, title: String, moodView: MoodView)
    {
        let frame = CGRectMake(0, 0, width, DEFAULT_HEIGHT)
        self.moodView = moodView
        
        super.init(frame: frame)
        
        self.backgroundColor = self.color
        self.backgroundColor = self.color.colorWithAlphaComponent(DEFAULT_BUTTON_OPACITY)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = DEFAULT_HEIGHT/2
        self.layer.borderColor = UIColor(netHex:0x64bf6b).CGColor
        self.layer.borderWidth = 2.0
        self.adjustsImageWhenHighlighted = false
        
        self.setTitle(title, forState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
        
        self.addTarget(self, action: "touchDown", forControlEvents: UIControlEvents.TouchDown)
        self.addTarget(self, action: "touchUpInside", forControlEvents: UIControlEvents.TouchUpInside)
        self.addTarget(self, action: "touchUpOutside", forControlEvents: UIControlEvents.TouchUpOutside)
    }
    
    public func changeColor(color: UIColor)
    {
        self.color = color
        self.setTitleColor(UIColor(netHex:0x4bf6b), forState: UIControlState.Normal)
        self.backgroundColor = self.color.colorWithAlphaComponent(DEFAULT_BUTTON_OPACITY)
    }
    
    public func touchDown()
    {
        self.backgroundColor = self.color.colorWithAlphaComponent(DEFAULT_BUTTON_OPACITY_TAPPED)
        self.setTitleColor(UIColor(netHex:0x4bf6b), forState: UIControlState.Normal)
        println("button tapped")
    }
    
    public func touchUpInside()
    {
        UIView.animateWithDuration(0.5, animations:
            {
                self.backgroundColor = self.color.colorWithAlphaComponent(self.DEFAULT_BUTTON_OPACITY)
                self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        })
        
        //print MoodView array
        moodView.printBooleans()
    }
    
    public func touchUpOutside()
    {
        self.backgroundColor = self.color.colorWithAlphaComponent(DEFAULT_BUTTON_OPACITY)
        self.setTitleColor(UIColor(netHex:0x4bf6b), forState: UIControlState.Normal)
    }
    
    public required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}