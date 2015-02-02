//
//  MoodCollectionView.swift
//  Optimist
//
//  Created by Jacob Johannesen on 1/30/15.
//  Copyright (c) 2015 MonsterCreate. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

public class MoodView: UIView
{
    var texts1: [String] = ["angry"];
    var texts2: [String] = ["anxious", "annoyed"];
    var texts3: [String] = ["depressed", "down", "heartbroken"];
    var texts4: [String] = ["hopeless", "hurting"];
    var texts5: [String] = ["irritatable", "mournful", "sad"];
    var texts6: [String] = ["pissed", "regretful"];
    var texts7: [String] = ["resentful", "scared", "sick"];
    var texts8: [String] = ["stressed", "nervous"];
    var texts9: [String] = ["sulky", "worthless"];
    
    var booleanArr: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    
    let DEFAULT_HEIGHT: CGFloat = 36.0
    let DEFAULT_WIDTH: CGFloat = 150.0
    let DEFAULT_MAX_WIDTH: CGFloat = 400.0
    let NUM_LINES: Int = 9;
    let DEFAULT_PADDING: CGFloat = 10.0
    let TEXT_SCALING_FACTOR: CGFloat = 18.0
    
    var trackIndex: Int = 0;
    
    public override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        var lines: [UIView] = [createLine(texts1), createLine(texts2), createLine(texts3), createLine(texts4), createLine(texts5), createLine(texts6), createLine(texts7), createLine(texts8), createLine(texts9)];
        
        for var index = 0; index < NUM_LINES; index++
        {
            lines[index].frame = CGRect(x: (self.frame.width / 2) - (lines[index].frame.width / 2), y: 0 + (DEFAULT_HEIGHT + DEFAULT_PADDING) * CGFloat(index), width: lines[index].frame.width, height: lines[index].frame.height);
            
            self.addSubview(lines[index])
        }
    }
    

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLine(texts: [String]) -> UIView
    {
        let numTexts = countElements(texts);
        
        var totalLengthUsed: CGFloat = 0
        var endResultTotal: CGFloat = 0
        
        for var index = 0; index < numTexts; index++
        {
            let dynamicButtonWidth = calculateWidth(texts[index])
            
            endResultTotal = endResultTotal + DEFAULT_PADDING + dynamicButtonWidth;
        }
        
        var lineView = UIView(frame: CGRect(x: 0, y: 0, width: endResultTotal, height: DEFAULT_HEIGHT))
        
        for var index = 0; index < numTexts; index++
        {
            let dynamicButtonWidth = calculateWidth(texts[index])
            
            let moodButton = MoodButton(width: dynamicButtonWidth, title: texts[index], moodView: self, index: trackIndex);
            moodButton.frame = CGRect(x: totalLengthUsed, y: 0, width: moodButton.frame.width, height: moodButton.frame.height);
            
            lineView.addSubview(moodButton);
            
            totalLengthUsed = totalLengthUsed + DEFAULT_PADDING + dynamicButtonWidth;
            
            trackIndex++;
        }
        
        return lineView;
    }
    
    func printBooleans()
    {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(booleanArr, forKey: "theBool")
        defaults.synchronize()
        
        for element in booleanArr
        {
            println("boolean is \(element)")
        }
    }
    
    func calculateWidth(thisText: String) -> CGFloat
    {
        var CalculatedWidth = CGFloat(countElements(thisText)) * TEXT_SCALING_FACTOR
        
        if(CalculatedWidth > 120)
        {
            CalculatedWidth = 120;
        }
        
        return CalculatedWidth
    }
}