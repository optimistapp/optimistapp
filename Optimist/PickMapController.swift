//
//  MapController.swift
//  optimismMap
//
//  Created by Johnson Zhou on 1/30/15.
//  Copyright (c) 2015 Johnson Zhou. All rights reserved.
//

import UIkit
import MapKit

class PickMapController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    required init(coder aDecoder: NSCoder) {
        self.locationManger = CLLocationManager()
        self.popOver = WYPopoverController() // Controlls the CallOut View
        super.init(coder: aDecoder)
        self.locationManger.delegate = self
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    var feeling = 0
    var packageList:NSMutableArray = NSMutableArray()
    var locationManger:CLLocationManager
    var mapPackages = []
    var popOver:WYPopoverController
    var isTracking = true
    
    
    @IBAction func pressCenter(sender: UIBarButtonItem) {
        isTracking = true
        self.MainMap.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }
    
    @IBOutlet weak var MainMap: MKMapView!
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        if isTracking {
            self.MainMap.setCenterCoordinate(userLocation.location.coordinate, animated: true)
        }
        reloadAnnotation()
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if (overlay.isKindOfClass(MKTileOverlay)) {
            return MKTileOverlayRenderer(overlay: overlay)
        } else
        {
            return nil;
        }
    }
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func mapView(mapView: MKMapView!, regionWillChangeAnimated animated: Bool) {
        isTracking = false
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var status : [Bool] = [Bool]()
        if let testArray : AnyObject? = defaults.objectForKey("theBool") {
            status = testArray! as [Bool]
        }
        
        //var status:[Bool] = [Bool](count:20, repeatedValue:true)

        
        self.locationManger.requestWhenInUseAuthorization()
        self.MainMap.delegate = self
        self.MainMap.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        self.MainMap.pitchEnabled = false
        var request = NSMutableURLRequest(URL: NSURL(string: "http://www.coryamayer.com/optimism/query.php")!)
        let dicLat = "&lat="
        let dicLon = "&lon="
        var dicMotion = ["angry","anxious","annoyed","depressed","down","heartbroken","hopeless","hurting",
            "irritable","mournful","nervous","pissed","regretful","resentful","sad","scared","sick","stressed","sulky"
            ,"worthless"]
        
        var requestString = "key=hack"
        requestString = requestString + dicLat + self.MainMap.userLocation.coordinate.latitude.description + dicLon + self.MainMap.userLocation.coordinate.latitude.description
        for index in 0...19 {
            requestString = requestString + "&" + dicMotion[index] + "="
            if status[index] {
                requestString = requestString + "1"
            } else {
                requestString = requestString + "0"
            }
        }
        var requestData = requestString.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        request.HTTPBody = requestData
        var returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        NSLog(NSString(data: returnData!, encoding: NSUTF8StringEncoding)!)
        var returnDic = NSPropertyListSerialization.propertyListWithData(returnData!, options: 0, format: nil, error: nil) as NSDictionary
        var NumString = returnDic["numberOfPins"] as NSString
        var NumCount = NumString.integerValue
        
        var thisPackage:NSDictionary
        var lat:NSString
        var lon:NSString
        for index in 0...(NumCount-1) {
            thisPackage = returnDic[String(index)] as NSDictionary
            lat = thisPackage["lat"] as NSString
            lon = thisPackage["lon"] as NSString
            packageList.addObject(beamPackage(beamMsg: thisPackage["message"] as String, LocLat: lat.doubleValue, LocLon: lon.doubleValue))
            
        }
        
        let template = "http://otile1.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.jpg"
        var overlay = MKTileOverlay(URLTemplate: template)
        overlay.canReplaceMapContent = true
        
        self.MainMap.addOverlay(overlay, level: MKOverlayLevel.AboveLabels)
        
        for currentItem in packageList {
            var thisItem = currentItem as beamPackage
            self.MainMap.addAnnotation(beamAnnotation(msg: thisItem.msg, location: CLLocationCoordinate2DMake(thisItem.lat, thisItem.lon)))
        }
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var currentLocation = self.MainMap.userLocation.coordinate
        var annotationView:MKAnnotationView?
        if annotation.isKindOfClass(beamAnnotation) {
            var thisLocation = annotation as beamAnnotation
            let thisLat:Double = thisLocation.coordinate.latitude
            let currentLat:Double = currentLocation.latitude
            let closeLat = fabs(currentLat - thisLat) < 0.0002
            let closeLong = fabs(thisLocation.coordinate.longitude - currentLocation.longitude) < 0.0002
            if (closeLat && closeLong) {
                 annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("AnnoUnlock")
                if annotationView == nil {
                    annotationView = thisLocation.annotationViewUnlocked()
                } else {
                    annotationView?.annotation = annotation
                }
            } else {
                annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("AnnoLock")
                if annotationView == nil {
                    annotationView = thisLocation.annotationViewLocked()
                } else {
                    annotationView?.annotation = annotation
                }
            }
            return annotationView
        }
        else {
          return nil
        }
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
       mapView.deselectAnnotation(view.annotation, animated: true)
        if (view.annotation.isKindOfClass(beamAnnotation)) {
            var thisAnnotation = view.annotation as beamAnnotation
            var controller = CallOutViewController(nibName: "CallOutViewController", bundle: nil)
            controller.msg = thisAnnotation.msg
            controller.preferredContentSize = CGSizeMake(240,150)
            popOver = WYPopoverController(contentViewController: controller)
            var thisLocation = thisAnnotation.coordinate
            var currentLocation = self.MainMap.userLocation.coordinate
            let thisLat:Double = thisLocation.latitude
            let currentLat:Double = currentLocation.latitude
            let closeLat = fabs(currentLat - thisLat) < 0.0002
            let closeLong = fabs(thisLocation.longitude - currentLocation.longitude) < 0.0002
            if (closeLat && closeLong) {
                popOver.presentPopoverFromRect(view.bounds,inView:view,permittedArrowDirections:WYPopoverArrowDirection.Any, animated:true, options: WYPopoverAnimationOptions.FadeWithScale)
            }
        }
        
        
    }
    
    func reloadAnnotation() {
        
        var currentLocation:MKAnnotation? = self.MainMap.userLocation
        var annotations = self.MainMap.annotations
        self.MainMap.removeAnnotations(annotations)
        if currentLocation != nil {
            self.MainMap.addAnnotation(currentLocation)
        }
        
        for currentItem2 in packageList {
            var thisItem = currentItem2 as beamPackage
            self.MainMap.addAnnotation(beamAnnotation(msg: thisItem.msg, location: CLLocationCoordinate2DMake(thisItem.lat, thisItem.lon)))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
