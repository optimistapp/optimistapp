//
//  TabViewController.swift
//  Optimist
//
//  Created by Johnson Zhou on 1/31/15.
//  Copyright (c) 2015 Optimist. All rights reserved.
//

import UIKit

class TabViewController: UIViewController {
    
    let SUN_BAR_HEIGHT: CGFloat = 80.0
    let TEXT_AREA_HEIGHT: CGFloat = 100.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(netHex:0xfffdd7)
        self.navigationController!.navigationBar.tintColor = UIColor(netHex:0xfffdd7)
        
        let moodView = MoodView(frame: CGRect(x: 0, y: SUN_BAR_HEIGHT + TEXT_AREA_HEIGHT - 20, width: self.view.frame.width, height: self.view.frame.height - SUN_BAR_HEIGHT - TEXT_AREA_HEIGHT))
        self.view.addSubview(moodView)
        
        let friendlyText = UILabel(frame: CGRectMake(16, 100, 400, 21))
        friendlyText.text = "this is for someone who feels..."
        friendlyText.font = UIFont.systemFontOfSize(20)
        friendlyText.textColor = UIColor(netHex:0xFFB242)
        self.view.addSubview(friendlyText)
        
        let acceptButton = AcceptButton(width: 200, title: "Accept", moodView: moodView)
        acceptButton.frame = CGRect(x: self.view.frame.width / 2 - acceptButton.frame.width / 2, y: self.view.frame.height - 64, width: acceptButton.frame.width, height: acceptButton.frame.height)
        acceptButton.addTarget(self, action: "buttonAction:", forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(acceptButton)
        
        let textArea = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: TEXT_AREA_HEIGHT))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func buttonAction(sender:UIButton) {
        self.performSegueWithIdentifier("PushSegue", sender: self)
    }

    @IBAction func Cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
