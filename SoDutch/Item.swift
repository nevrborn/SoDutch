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
    var dateCreated: NSDate
    var originalImage: UIImage?
    var editedImage: UIImage?
    var longitude: Double
    var latitude: Double
    var tags: [String]
    var comments: [String]
    var likes: Int
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
        self.dateCreated = NSDate()
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.itemKey = NSUUID().UUIDString
        self.likes = 0
        self.tags = []
        self.comments = []
    }
    
    // annotation callout opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(CNPostalAddressStreetKey): self.itemTitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.itemTitle
        
        return mapItem
    }
    


    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(itemTitle, forKey: "itemTitle")
        aCoder.encodeObject(itemDescription, forKey: "itemDescription")
        aCoder.encodeObject(dateCreated, forKey: "dateCreated")
        aCoder.encodeDouble(latitude, forKey: "latitude")
        aCoder.encodeDouble(longitude, forKey: "longitude")
        aCoder.encodeObject(originalImage, forKey: "originalImage")
        aCoder.encodeObject(editedImage, forKey: "editedImage")
        aCoder.encodeObject(tags, forKey: "tags")
        aCoder.encodeObject(comments, forKey: "comments")
        aCoder.encodeInteger(likes, forKey: "likes")
        aCoder.encodeObject(itemKey, forKey: "itemKey")
    }
    
    required init(coder aDecoder: NSCoder) {
        itemTitle = aDecoder.decodeObjectForKey("itemTitle") as! String
        itemDescription = aDecoder.decodeObjectForKey("itemDescription") as! String
        dateCreated = aDecoder.decodeObjectForKey("dateCreated") as! NSDate
        latitude = aDecoder.decodeDoubleForKey("latitude")
        longitude = aDecoder.decodeDoubleForKey("longitude")
        originalImage = aDecoder.decodeObjectForKey("originalImage") as? UIImage
        editedImage = aDecoder.decodeObjectForKey("editedImage") as? UIImage
        tags = aDecoder.decodeObjectForKey("tags") as! [String]
        comments = aDecoder.decodeObjectForKey("comments") as! [String]
        likes = aDecoder.decodeIntegerForKey("likes") 
        itemKey = aDecoder.decodeObjectForKey("itemKey") as! String
        
        super.init()
    }
    
    
}
