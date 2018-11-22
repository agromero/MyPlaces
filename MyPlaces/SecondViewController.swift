//
//  SecondViewController.swift
//  MyPlaces
//
//  Created by user143154 on 9/20/18.
//  Copyright © 2018 user143154. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController, MKMapViewDelegate, ManagerPlacesObserver {

    @IBOutlet weak var m_map: MKMapView!
    
    let m_location_manager: ManagerLocation = ManagerLocation.shared()
    let m_places_manager:ManagerPlaces = ManagerPlaces.shared()
    let m_display_manager : ManagerDisplay = ManagerDisplay.shared()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        m_display_manager.ApplyBackground(v: self.view)
        m_display_manager.ApplyNavigationBarStyle(vc: self)
        
        self.m_map.mapType = MKMapType.standard
        self.m_map.delegate = self
        m_places_manager.addObserver(object: self)

        AddMarkers()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func RemoveMarkers()
    {
        let lista = self.m_map.annotations.filter { !($0 is MKUserLocation) }
        self.m_map.removeAnnotations(lista)
    }

    
    func AddMarkers()
    {
        for i in 0..<m_places_manager.GetCount() {
            let item = m_places_manager.GetItemAt(position: i)
            
            let title:String = item.name
            let id:String = item.id
            let lat:Double = item.location.latitude
            let lon:Double = item.location.longitude
            
            let annotation:MKMyPointAnnotation = MKMyPointAnnotation(coordinate:
                CLLocationCoordinate2D(latitude: lat,longitude: lon),title: title,place_id: id)
            
            self.m_map.addAnnotation(annotation)
        }
        
            //Add my position
            let title:String = "Me"
            let id:String = "0000"
            let lat:Double = self.m_location_manager.GetLocation().latitude
            let lon:Double = self.m_location_manager.GetLocation().longitude
            
            let annotation:MKMyPointAnnotation = MKMyPointAnnotation(coordinate:
                CLLocationCoordinate2D(latitude: lat,longitude: lon),title: title,place_id: id)
            
            self.m_map.addAnnotation(annotation)
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let annotation = annotation as? MKMyPointAnnotation
        {
            
            let identifier = "CustomPinAnnotationView"
            var pinView: MKPinAnnotationView
            if let dequeuedView =
                self.m_map?.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            } else {
                
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinView.canShowCallout = true
                
                pinView.calloutOffset = CGPoint(x: -5, y: 5)
                pinView.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
                if annotation.place_id=="0000"{
                    pinView.pinTintColor = UIColor.blue
                }
                pinView.setSelected(true,animated: true)
            }
            return pinView
        }
        return nil
    }

    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        let annotation:MKMyPointAnnotation = annotationView.annotation as! MKMyPointAnnotation
        
        // Mostrar el DetailController de ese Place

        let place = m_places_manager.GetItemById(id: annotation.place_id)        
        /*
         let current_lat = self.m_location_manager.GetLocation().latitude
         let current_long = self.m_location_manager.GetLocation().longitude
         let current_loc:CLLocation  = CLLocation(latitude: current_lat , longitude: current_long)
         
         let place_loc:CLLocation = CLLocation(latitude: annotation.coordinate.latitude,longitude: annotation.coordinate.longitude)
         
         let distance:CLLocationDistance = (current_loc.distance(from: place_loc))
         
        let string1:String = "To:\(String(describing: annotation.title)) a float:\(distance)"
         */
        

        let dc:DetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        dc.place = place
        
        present(dc, animated: true, completion: nil)

        }

    
    func onPlacesChange()
    {
        self.RemoveMarkers()
        self.AddMarkers()
    }

}

