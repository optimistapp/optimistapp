//
//  CallOutViewController.swift
//  optimismMap
//
//  Created by Johnson Zhou on 1/31/15.
//  Copyright (c) 2015 Optmist. All rights reserved.
//

import UIKit


//if you don't understand this, you really need to change your major

class CallOutViewController: UIViewController,UITextViewDelegate {

    @IBOutlet var textView: UITextView!
    var msg:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = msg    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
     convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    

}
