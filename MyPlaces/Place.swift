//
//  Place.swift
//  MyPlaces
//
//  Created by user143154 on 9/25/18.
//  Copyright © 2018 user143154. All rights reserved.
//

import Foundation
import MapKit



class Place : Codable {

    enum PlacesTypes: Int, Codable {
        case GenericPlace
        case TouristicPlace
    }
    
    //Enum per al JSON
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case name
        case type
        case latitude
        case longitude
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
    
    //enconding i decoding per al JSON
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy:CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        
        // Para la location, grabamos sus componentes latitud y
        //longitud por separado.
        try container.encode(location.latitude, forKey:.latitude)
        try container.encode(location.longitude, forKey:.longitude)
    }
    
    func decode(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy:CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(PlacesTypes.self, forKey: .type)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey:.description)
        
        let latitude = try container.decode(Double.self, forKey:.latitude)
        let longitude = try container.decode(Double.self, forKey:.longitude)
        
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        try decode(from: decoder)
    }
}



class PlaceTourist: Place {
    
    var discount_tourist = ""
    
    //Enum per al JSON
    enum CodingKeysTourist: String, CodingKey {
        case discount_tourist
    }
    
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
    
     //enconding i decoding per al JSON
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy:
            CodingKeysTourist.self)
        try container.encode(discount_tourist, forKey:
            .discount_tourist)
        try super.encode(to: encoder)
    }

    override func decode(from decoder: Decoder) throws
    {
        try super.decode(from:decoder)
        let container = try decoder.container(keyedBy:CodingKeysTourist.self)
        discount_tourist = try container.decode(String.self, forKey:.discount_tourist)
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        try decode(from:decoder)
    }
}
