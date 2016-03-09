//
//  ImageStore.swift
//  SoDutch
//
//  Created by Jarle Matland on 08.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit

class ImageStore: NSObject {
    
    let cache = NSCache()
    
    // Saves an image to a specific URL
    func setImage(image: UIImage, forKey key: String, original: Bool) {
        cache.setObject(image, forKey: key)
        
        // Create full URL for image
        if original == true {
            let orginialImageURL = originalImageURLForKey(key)
            // Turn image into PNG data
            if let data = UIImagePNGRepresentation(image) {
                // Write it to full URL
                data.writeToURL(orginialImageURL, atomically: true)
            }
        } else {
            let editedImageURL = editedImageURLForKey(key)
            // Turn image into PNG data
            if let data = UIImagePNGRepresentation(image) {
                // Write it to full URL
                data.writeToURL(editedImageURL, atomically: true)
            }
        }

    }
    
    // Gets the edited image
    func editedImageForKey(key: String) -> UIImage? {
        
        if let existingImage = cache.objectForKey(key) as? UIImage {
            return existingImage
        }
        
        let imageURL = editedImageURLForKey(key)
        guard let editedImageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
            return nil
        }
        
        cache.setObject(editedImageFromDisk, forKey: key)
        return editedImageFromDisk
    }
    
    // Gets the originalImage
    func originalImageForKey(key: String) -> UIImage? {
        
        if let existingImage = cache.objectForKey(key) as? UIImage {
            return existingImage
        }
        
        let imageURL = originalImageURLForKey(key)
        guard let originalImageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
            return nil
        }
        
        cache.setObject(originalImageFromDisk, forKey: key)
        return originalImageFromDisk
    }
    
    // Gets an URL for the editedImage
    func editedImageURLForKey(key: String) -> NSURL {
        
        let documentDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentDirectories.first!
        
        return documentDirectory.URLByAppendingPathComponent(key)
    }
    
    // Gets an URL for the originalImage
    func originalImageURLForKey(key: String) -> NSURL {
        
        let documentDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentDirectories.first!
        
        return documentDirectory.URLByAppendingPathComponent(key)
    }
    
    
}
