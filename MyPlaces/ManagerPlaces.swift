//
//  ManagerPlaces.swift
//  MyPlaces
//
//  Created by user143154 on 9/25/18.
//  Copyright © 2018 user143154. All rights reserved.
//

import Foundation
import MapKit



protocol ManagerPlacesObserver
{
    func onPlacesChange()
}

class ManagerPlaces
{
    //******************************
    //Observador
    public var m_observers = Array<ManagerPlacesObserver>()
    var places:[Place] = []
    //******************************
 
    //******************************
    //Singleton
    //
    static var shared = ManagerPlaces()
    //******************************
 

    func append(_ value:Place)
    {
        places.append(value)
    }
    
    func GetCount() ->Int
    {
        return places.count
    }
    
    func GetItemAt(position: Int) -> Place
    {
        return places[position]
    }
    
    func GetItemById(id:String) -> Place
    {
        return places.filter( { $0.id == id})[0]
    }
    
    func remove(_ value:Place)
    {
        //Amb el filter eliminant per id
        places = places.filter( { $0.id != value.id} )
        
        //Amb el filter eliminant per Place
        //places = places.filter( { $0 !== value} )
    }
    
    public func addObserver(object:ManagerPlacesObserver){
        m_observers.append(object)
    }
    
    public func UpdateObservers() {
        
        m_observers[0].onPlacesChange()

        /* Codi preparat per quan hi hagi varios observadors
         
        let numObservers = m_observers.count
        if numObservers > 0 {
            for i in 0..<numObservers {
             m_observers[i].onPlacesChange()
            }
        }
        */ 

    }
    

}

