//
//  ManagerLocation.swift
//  MyPlaces
//
//  Created by user143154 on 10/17/18.
//  Copyright © 2018 user143154. All rights reserved.
//

import Foundation
import MapKit
import UserNotifications

class ManagerLocation: NSObject, CLLocationManagerDelegate
{
    var m_locationManager:CLLocationManager!
    
    var firsTime:Bool = true
    
    
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
                //singletonManager!.m_locationManager.startUpdatingLocation()
                singletonManager!.startLocation()
            }
            
            //Pedimos permiso para lanzar las notificaciones locales
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge])
            { (granted, error) in
                // Enable or disable features based on authorization.
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


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        
        if (status == .authorizedWhenInUse) {
            self.m_locationManager.startUpdatingLocation()
        }
    }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let location:CLLocation = locations[locations.endIndex-1]
        
        if(firsTime){
            let content = UNMutableNotificationContent()
            content.title = "Notificació de Proximitat"
            content.subtitle = "Estas acercándote a un Place"
            content.body = "Mira la descripción del place para más información"
            content.badge = 1
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            let requestIdentifier = "demoNotification"
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request,withCompletionHandler: { (error) in })
            // Handle error

            firsTime = false;
        }
    }
    
}

