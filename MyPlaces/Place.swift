//
//  Place.swift
//  MyPlaces
//
//  Created by user143154 on 9/25/18.
//  Copyright © 2018 user143154. All rights reserved.
//

import Foundation
import MapKit



class Place {

    enum PlacesTypes: Int {
        case GenericPlace
        case TouristicPlace
    }
    
    var id: String = ""
    var type: PlacesTypes = .GenericPlace
    var name: String = ""
    var description: String = ""
    var location: CLLocationCoordinate2D!
    var image:Data? = nil
    
    init()
    {
        
    }

    init (name:String, description: String, image_in:Data?)
    {
        self.id=UUID().uuidString
        self.name = name
        self.description = description
        self.image = image_in
    }
    
    init (type:PlacesTypes, name:String, description:String, image_in:Data?)
    {
        self.id=UUID().uuidString
        self.type = type
        self.name = name
        self.description = description
        self.image = image_in
    }
}

class PlaceTourist: Place {
    
    var discount_tourist = ""
    
    override init()
    {
        super.init()
        type = .TouristicPlace
    }
    
    init(name:String,description:String,discount_tourist:String,image_in:Data?)
    {
        super.init(type:.TouristicPlace,name:name,description:description,image_in:image_in)
        self.discount_tourist = discount_tourist
    }
    
}


