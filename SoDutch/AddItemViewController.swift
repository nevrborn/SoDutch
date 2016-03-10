//
//  AddItemViewController.swift
//  SoDutch
//
//  Created by Jarle Matland on 07.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit
import CoreLocation

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    var currentLocation: CLLocation!
    var locationManager: CLLocationManager!
    
    var itemsStore: ItemsStore!
    var imageStore: ImageStore!
    
    var originalImageData: NSData!
    var editedImageData: NSData!
    
    var newItem: Item!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var addresseLabel: UILabel!
    @IBOutlet var descriptionField: UITextField!
    @IBOutlet var tagsField: UITextField?
    @IBOutlet var titleTextView: UIView!
    
    // Actions that happen when user presses DONE
    @IBAction func finishItem(sender: AnyObject) {
        
        newItem = itemsStore.addItem(titleField.text!, newDescription: descriptionField.text!, newLocation: currentLocation)
        
        newItem.originalImage = UIImage(data: originalImageData)
        newItem.editedImage = UIImage(data: editedImageData)
        
        itemsStore.saveChanges()
        
        imageView.image = nil
        titleField.text = ""
        addresseLabel.text = ""
        descriptionField.text = ""
        tagsField!.text = ""
        
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ItemViewController") as! ItemViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    // Opens up the camera to take a picture
    @IBAction func takePicture(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = true
        
        // Place image picker on the screen
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
     // Take a photo and saves both the original and edited photo
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get picked image from info dictionary
        let originalImageInit = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImageInit = info[UIImagePickerControllerEditedImage] as! UIImage
        
        originalImageData = UIImagePNGRepresentation(originalImageInit)
        editedImageData = UIImagePNGRepresentation(editedImageInit)
        
        // Display the edited (small) image on screen
        imageView.image = editedImageInit
        
        // Get adresseLabel as current location
        getLocationAddress(currentLocation)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Convert the CLLocation coordinates to an addresse
    func getLocationAddress(location:CLLocation) -> String {
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
        
        addresseLabel.text = "Addresse will come automatically with picture"
        
        newItem = itemsStore.addItem("No Title", newDescription: "No Description", newLocation: currentLocation)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

}
