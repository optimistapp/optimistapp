//
//  beamAnnotation.swift
//  optimismMap
//
//  Created by Johnson Zhou on 1/31/15.
//  Copyright (c) 2015 Optimist. All rights reserved.
//

import Foundation
import MapKit

class beamAnnotation:NSObject,MKAnnotation {
    
    var coordinate:CLLocationCoordinate2D
    var msg:String
    var locked = true
    
    init(msg:String, location:CLLocationCoordinate2D) {
        coordinate = location
        self.msg = msg
    }
    
    //annotation for unlocked item
    func annotationViewUnlocked() -> MKAnnotationView{
        var annotationView = MKAnnotationView(annotation: self, reuseIdentifier: "AnnoUnlock")
        annotationView.enabled = true
        annotationView.canShowCallout = false
        annotationView.image = UIImage(named: "unlocked.png")
        self.locked = false
        return annotationView
    }
    
    //annotation for locked item
    func annotationViewLocked() -> MKAnnotationView{
        var annotationView = MKAnnotationView(annotation: self, reuseIdentifier: "AnnoLock")
        annotationView.enabled = true
        annotationView.canShowCallout = false
        annotationView.image = UIImage(named:"locked.png")
        self.locked = true
        return annotationView
    }
    
}