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

class ManagerPlaces : Codable {
    //******************************
    //Observador
    public var m_observers = Array<ManagerPlacesObserver>()
    var places:[Place] = []
    //******************************
 
    //******************************************
    // Singleton
    //old Singleton
    //
    //static var shared = ManagerPlaces
    //
 
    private static var sharedManagerPlaces: ManagerPlaces = {

        var singletonManager: ManagerPlaces?
        
        singletonManager = load()
        if (singletonManager == nil){
            singletonManager = ManagerPlaces()
        }
        return singletonManager!
    }()

    class func shared() -> ManagerPlaces {
        return sharedManagerPlaces
     }
    
    // ****************************************
    
    //******************************
    //enums per al JSON
    //
    enum CodingKeys: String, CodingKey {
        case places
    }
    enum PlacesTypeKey: CodingKey {
        case type
    }
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
    
    //Funcions relacionades amb el filesystem i JSON
    //
    func GetPathImage(p:Place)->String
    {
        let r = FileSystem.GetPathImage(id:p.id)
        return r;
    }
    
    //Funcions dels observadors
    //
    public func addObserver(object:ManagerPlacesObserver){
        m_observers.append(object)
    }
    
    public func UpdateObservers() {
            for observer in m_observers {
             observer.onPlacesChange()
            }
    }

    //enconding i decoding per al JSON
    //
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy:CodingKeys.self)
        try container.encode(places, forKey: .places)
    }

   
    func decode(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy:CodingKeys.self)
        places = [Place]()
        var objectsArrayForType = try
            container.nestedUnkeyedContainer(forKey: CodingKeys.places)
        var tmp_array = objectsArrayForType
        while(!objectsArrayForType.isAtEnd)
        {
            let object = try objectsArrayForType.nestedContainer(keyedBy: PlacesTypeKey.self)
            let type = try object.decode(Place.PlacesTypes.self, forKey: PlacesTypeKey.type)
            switch type {
                case Place.PlacesTypes.TouristicPlace:
                    self.append(try tmp_array.decode(PlaceTourist.self))
                default :
                    self.append(try tmp_array.decode(Place.self))
            }
        }
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        try decode(from:decoder)
    }
    
    func store()
    {
        do{
	        let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            for place in places {
                if(place.image != nil){
                    FileSystem.WriteData(id:place.id,image:place.image!)
                    place.image = nil;
                }
            }
            FileSystem.Write(data: String(data: data, encoding:.utf8)!)
        }
        catch
        {
        }
    }
    
    static func load() -> ManagerPlaces?
    {
        var resul:ManagerPlaces? = nil
        let data_str = FileSystem.Read()
        if(data_str != "") {
            do{
                let decoder = JSONDecoder()
                let data:Data = Data(data_str.utf8)
                resul = try decoder.decode(ManagerPlaces.self,from:data)
            }
            catch
            {
                resul = nil
            }
        }
        return resul
    }

}

