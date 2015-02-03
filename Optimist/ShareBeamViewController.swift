//
//  ShareBeamViewController.swift
//  Optimist
//
//  Created by Johnson Zhou on 1/31/15.
//  Copyright (c) 2015 Optimist. All rights reserved.
//

import UIKit

class ShareBeamViewController: UIViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }   //this hides the keyboard
    
    @IBOutlet weak var shareBeam: UITextView!
    
    /*
    No need, auto gen by push segue
    @IBAction func exitView(sender: AnyObject) {
        
              self.navigationController?.popViewControllerAnimated(true)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //sending information to other viewcontrollers, place holder, need to update
        var prefs = NSUserDefaults.standardUserDefaults()
        prefs.setObject(shareBeam.text,forKey:"BeamText")
        prefs.synchronize()
    }
    
}
