//
//  DropMapViewController.swift
//  optimismMap
//
//  Created by Johnson Zhou on 1/31/15.
//  Copyright (c) 2015 Johnson Zhou. All rights reserved.
//

import UIKit
import MapKit

class DropMapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    var thisPackage:beamPackage
    var msgString = ""
    var status:[Bool] = [Bool](count:20, repeatedValue:true)
    
    
    
    @IBAction func goBack(sender: AnyObject) {
      self.navigationController?.popViewControllerAnimated(true)
    }
    required init(coder aDecoder: NSCoder) {
        
        self.locationManager = CLLocationManager()
        thisPackage = beamPackage(beamMsg: msgString, LocLat: 0, LocLon: 0)
        super.init(coder: aDecoder)
    }
    
    var locationManager:CLLocationManager
    
    @IBOutlet weak var MainMap: MKMapView!
    
    @IBAction func DropBeam(sender: AnyObject) {
        
        let myDelegate = AppDelegate()
        var currentLocation = self.MainMap.userLocation.coordinate
        thisPackage = beamPackage(beamMsg: msgString, LocLat: currentLocation.latitude, LocLon: currentLocation.longitude)
        let dicKey = "key="
        let dicUser = "&user="
        let dicLat = "&lat="
        let dicLon = "&lon="
        let dicMessage = "&message="
        var dicMotion = ["angry","anxious","annoyed","depressed","down","heartbroken","hopeless","hurting",
        "irritable","mournful","nervous","pissed","regretful","resentful","sad","scared","sick","stressed","sulky"
        ,"worthless"]
        var requestString = dicKey + "hack2015"
        requestString = requestString + dicUser + UIDevice.currentDevice().identifierForVendor.UUIDString
        requestString = requestString + dicLat + thisPackage.lat.description
        requestString = requestString + dicLon + thisPackage.lon.description + dicMessage + thisPackage.msg
        NSLog(thisPackage.msg)
        for index in 0...19 {
            requestString = requestString + "&" + dicMotion[index] + "="
            if status[index] {
                requestString = requestString + "1"
            } else {
                requestString = requestString + "0"
            }
        }
        var requestData = requestString.dataUsingEncoding(NSUTF8StringEncoding)
        var request = NSMutableURLRequest(URL: NSURL(string: "http://www.coryamayer.com/optimism/post.php")!)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        request.HTTPBody = requestData
        var returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        var returnString = NSString(data: returnData!, encoding:NSUTF8StringEncoding)
        if returnString!.isEqualToString("IK") {
            NSLog("invalid key")
        } else if returnString!.isEqualToString("SC") {
            NSLog("sucess")
        } else {
            NSLog("nope")
        }
        //self.navigationController?.popViewControllerAnimated(true)
        self.performSegueWithIdentifier("weirdPush", sender: self)
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        var coord = self.MainMap.userLocation.location.coordinate
        var region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
        self.MainMap.setRegion(region, animated: true)
    }
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if (overlay.isKindOfClass(MKTileOverlay)) {
            return MKTileOverlayRenderer(overlay: overlay)
        } else
        {
            return nil;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var prefs = NSUserDefaults.standardUserDefaults()
        
        //var status : [Bool] = [Bool]()
        if let testArray : AnyObject? = prefs.objectForKey("theBool") {
            status = testArray! as [Bool]
        }
        
        if let firstNameIsNotNill = prefs.objectForKey("BeamText") as? String {
            msgString = prefs.objectForKey("BeamText") as String
        }
        self.locationManager.requestWhenInUseAuthorization()
        self.MainMap.delegate = self
        self.MainMap.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        let template = "http://otile1.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.jpg"
        var overlay = MKTileOverlay(URLTemplate: template)
        overlay.canReplaceMapContent = true
        self.MainMap.addOverlay(overlay, level: MKOverlayLevel.AboveLabels)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
