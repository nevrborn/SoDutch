//
//  AddItemViewController.swift
//  SoDutch
//
//  Created by Jarle Matland on 07.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit
import CoreLocation
import Photos

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    var currentLocation: CLLocation!
    var locationManager: CLLocationManager!
    
    var itemsStore: ItemsStore!
    var imageStore: ImageStore!
    
    var originalImageData: NSData!
    var editedImageData: NSData!
    var addressString: String?
    var locationOfPhoto: CLLocation?
    
    var newItem: Item!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var addresseLabel: UILabel!
    @IBOutlet var descriptionField: UITextField!
    @IBOutlet var tagsField: UITextField?
    @IBOutlet var titleTextView: UIView!
    
    
    // Actions that happen when user presses DONE button
    @IBAction func finishItem(sender: AnyObject) {
        
        if (imageView.image == nil || titleField.text == "" || descriptionField.text == "") {
            
            
            let alertController = UIAlertController(title: "Missing information", message: "Photo, Title and Description is required to save", preferredStyle: .Alert)
            
            let completeAction = UIAlertAction(title: "OK", style: .Destructive, handler: nil)
            
            alertController.addAction(completeAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            
            newItem = itemsStore.addItem(titleField.text!, newDescription: descriptionField.text!, newLocation: locationOfPhoto!)
            
            // Set images directly to the item, NOT to ImageStore
            newItem.originalImage = UIImage(data: originalImageData)
            newItem.editedImage = UIImage(data: editedImageData)
            newItem.addressString = addresseLabel.text
            newItem.dateCreated = formatADate()
            
            itemsStore.saveChanges()
            
            imageView.image = nil
            titleField.text = ""
            addresseLabel.text = ""
            descriptionField.text = ""
            
            // This string contains some empty sections.
            let newTags = tagsField!.text?.componentsSeparatedByString(" ")
            
            // Use filter to eliminate empty strings.
            _ = newTags!.filter { (x) -> Bool in
                !x.isEmpty
            }
            
            for item in newTags! {
                newItem.tags.append(item)
            }
            
            tabBarController?.selectedIndex = 2
        }
    }
    
    // Opens up the camera to take a picture
    @IBAction func takePicture(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        
        // Asks the user to either Take a Photo or to choose one from the Photo Library
        let alertController = UIAlertController(title: "Add Photo", message: "Choose from Camera or from PhotoLibrary?", preferredStyle: .Alert)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {(action)-> Void in
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        })
        
        let libraryAction = UIAlertAction(title: "Get Photo From Library", style: .Default, handler: {(action)-> Void in
            imagePicker.delegate = self
            imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = true
        
        // Place image picker on the screen
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Take a photo and saves both the original and edited photo
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if picker.sourceType == UIImagePickerControllerSourceType.Camera {
            // Get picked image from info dictionary
            let originalImageInit = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImageInit = info[UIImagePickerControllerEditedImage] as! UIImage
            
            // Convert image to PNG
            originalImageData = UIImagePNGRepresentation(originalImageInit)
            editedImageData = UIImagePNGRepresentation(editedImageInit)
            
            // Display the edited (small) image on screen
            imageView.image = editedImageInit
            
            locationOfPhoto = currentLocation
            
            // Get adresseLabel as current location
            getLocationAddress(currentLocation)
            
            
        } else if picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary {
            
            var url: [NSURL] = []
            
            let originalImageInit = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImageInit = info[UIImagePickerControllerEditedImage] as! UIImage
            
            // Convert image to PNG
            originalImageData = UIImagePNGRepresentation(originalImageInit)
            editedImageData = UIImagePNGRepresentation(editedImageInit)
            
            let imageURL: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
          
            url.append(imageURL)
            
            let fetchedImage = PHAsset.fetchAssetsWithALAssetURLs(url, options: nil)
            
            let imageMetaData: PHAsset = fetchedImage.objectAtIndex(0) as! PHAsset
            
            // Display the edited (small) image on screen
            imageView.image = editedImageInit
            
            if imageMetaData.location != nil {
                let imageLocation: CLLocation = imageMetaData.location!
            
                locationOfPhoto = imageLocation

                getLocationAddress(imageLocation)
            } else {
                
                let alertController = UIAlertController(title: "No location associated with picture", message: "Will set location to current location", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "OK", style: .Destructive, handler: nil)
                
                alertController.addAction(okAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                locationOfPhoto = currentLocation
                
                getLocationAddress(locationOfPhoto!)
            }
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Convert the CLLocation coordinates to an addresse
    func getLocationAddress(location: CLLocation) -> String {
        let geocoder = CLGeocoder()
        var placemark: CLPlacemark!
        var addresseString: String = ""
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error)-> Void in
            
            if error == nil  {
                placemark = placemarks![0] as CLPlacemark
                
                if placemark.thoroughfare != nil {
                    addresseString = placemark.thoroughfare! + " "
                }
                if placemark.subThoroughfare != nil {
                    addresseString = addresseString + placemark.subThoroughfare!
                }
                if placemark.postalCode != nil {
                    addresseString = addresseString + ", " + placemark.postalCode! + " "
                }
                if placemark.locality != nil {
                    addresseString = addresseString + placemark.locality!
                }
                
                // Set adresseLabel as current location
                self.addresseLabel.text = addresseString
                
            }
        })
        
        return addresseString
    }
    
    override func viewDidLoad() {
        
        
        currentLocation = CLLocation!()
        locationManager = CLLocationManager()
        locationManager.startUpdatingLocation()
        
        currentLocation = locationManager.location
        
        imageView.layer.shadowColor = UIColor.blackColor().CGColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = CGSizeMake(4, 5)
        imageView.layer.shadowRadius = 10
        
        addresseLabel.text = "Addresse will come automatically with picture"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func formatADate() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let d = NSDate()
        let s = dateFormatter.stringFromDate(d)
        
        return s
    }
    
}
