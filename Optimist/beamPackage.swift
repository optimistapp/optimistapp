import Foundation

class beamPackage {
    
    let lat:Double  //lattitude
    let lon:Double  //longtitude
    let msg:String  //message
    
    init(beamMsg:String, LocLat:Double, LocLon:Double) {
        msg = beamMsg
        lat = LocLat
        lon = LocLon
    }
    
    
}