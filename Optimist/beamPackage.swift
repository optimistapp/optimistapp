import Foundation

class beamPackage {
    
    let lat:Double
    let lon:Double
    let msg:String
    
    init(beamMsg:String, LocLat:Double, LocLon:Double) {
        msg = beamMsg
        lat = LocLat
        lon = LocLon
    }
    
    
}