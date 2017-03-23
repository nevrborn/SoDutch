//
//  Item.swift
//  SoDutch
//
//  Created by Jarle Matland on 07.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import AddressBook
import Contacts

class Item: NSObject, NSCoding, MKAnnotation {
    
    var itemTitle: String
    var itemDescription: String
    var dateCreated: String = ""
    var editedImage: UIImage?
    var longitude: Double
    var latitude: Double
    var addressString: String?
    let itemKey: String
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D()
        }
        set {
            latitude = coordinate.latitude
            longitude = coordinate.longitude
        }
    }
    
    init(title: String, itemDescription: String, location: CLLocation) {
        self.itemTitle = title
        self.itemDescription = itemDescription
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.itemKey = UUID().uuidString
    }
    
    // Annotation callout opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(CNPostalAddressStreetKey): self.itemTitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.itemTitle
        
        return mapItem
    }
    
    // Encode all info about the objects
    func encode(with aCoder: NSCoder) {
        aCoder.encode(itemTitle, forKey: "itemTitle")
        aCoder.encode(itemDescription, forKey: "itemDescription")
        aCoder.encode(dateCreated, forKey: "dateCreated")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(addressString, forKey: "addressString")
        aCoder.encode(editedImage, forKey: "editedImage")
        aCoder.encode(itemKey, forKey: "itemKey")
    }
    
    // Decode all info about the objects
    required init(coder aDecoder: NSCoder) {
        itemTitle = aDecoder.decodeObject(forKey: "itemTitle") as! String
        itemDescription = aDecoder.decodeObject(forKey: "itemDescription") as! String
        dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! String
        latitude = aDecoder.decodeDouble(forKey: "latitude")
        longitude = aDecoder.decodeDouble(forKey: "longitude")
        addressString = aDecoder.decodeObject(forKey: "addressString") as? String
        editedImage = aDecoder.decodeObject(forKey: "editedImage") as? UIImage
        itemKey = aDecoder.decodeObject(forKey: "itemKey") as! String
        
        super.init()
    }
    
    
}
