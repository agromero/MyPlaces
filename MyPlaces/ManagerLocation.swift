//
//  ManagerLocation.swift
//  MyPlaces
//
//  Created by user143154 on 10/17/18.
//  Copyright © 2018 user143154. All rights reserved.
//

import Foundation
import MapKit

class ManagerLocation: NSObject, CLLocationManagerDelegate
{
    var m_locationManager:CLLocationManager!

    private static var sharedManagerLocation: ManagerLocation = {
        
        var singletonManager:ManagerLocation?
        
        if(singletonManager == nil) {
            singletonManager = ManagerLocation()
            
            singletonManager!.m_locationManager = CLLocationManager()
            
            singletonManager!.m_locationManager.delegate = singletonManager
            
            singletonManager!.m_locationManager.allowsBackgroundLocationUpdates = true // Permitir updates en background
            singletonManager!.m_locationManager.distanceFilter = 500 // Minima distancia para que detecte cambio de posición = 500 metros
            singletonManager!.m_locationManager.desiredAccuracy = kCLLocationAccuracyBest // Que use la forma más optima para calcular la geolocalización.
            

            let status:CLAuthorizationStatus = CLLocationManager.authorizationStatus()

            //Comprobar si la aplicación tiene permiso para obtener la posición del usuario
            if (status == CLAuthorizationStatus.notDetermined){
                singletonManager!.m_locationManager.requestWhenInUseAuthorization()
            }
            else{
                singletonManager!.m_locationManager.startUpdatingLocation()
                singletonManager!.startLocation()
            }
        }
        return singletonManager!
    }()

    class func shared() -> ManagerLocation {
        return sharedManagerLocation
    }
    
    func startLocation() {
        self.m_locationManager.startUpdatingLocation()
    }

    public func GetLocation()->CLLocationCoordinate2D {
        return (self.m_locationManager!.location?.coordinate)!
    }

    /*
     static var pos:Int = 0
     static var locations:[CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 41.387834, longitude: 2.170130),CLLocationCoordinate2D(latitude: 41.387834, longitude: 2.170130),CLLocationCoordinate2D(latitude: 41.391980, longitude: 2.196036),CLLocationCoordinate2D(latitude: 41.391980, longitude: 2.196036)]
     
 
     static func GetLocation()->CLLocationCoordinate2D
     {
     pos += 1
     if(pos>=locations.count) {
     pos = 0
     }
     
     return locations[pos]
     
     }
  */
    
}
