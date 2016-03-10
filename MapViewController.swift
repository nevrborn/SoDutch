//
//  MapViewController.swift
//  SoDutch
//
//  Created by Jarle Matland on 07.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var location: CLLocation!
    var locationManager: CLLocationManager!
    var window: UIWindow!
    var annotations = [MKPointAnnotation]()
    
    var itemsStore: ItemsStore!
    var imageStore: ImageStore!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var mapSegment: UISegmentedControl!
    
    // If pressing "ARROW" then the location will be zoomed in to users location
    @IBAction func goToCurrentLocation(sender: UIButton) {
        self.mapView.showsUserLocation = true
        mapView.setRegion(MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)), animated: true)
    }
    
    
    // Segmented controll to display Standard, Hybrid or Satelite
    @IBAction func mapTypeSegment(sender: UISegmentedControl) {
        
        let segmentedControl = sender
        segmentedControl.addTarget(self, action: "mapTypeChanged:", forControlEvents: .ValueChanged)
        
    }
    
    
    func mapTypeChanged(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            break
        }
    }
    
    // Segmented controll to display ALL or RECENT photos
    @IBAction func itemsViewSegment(sender: UISegmentedControl) {
        
    }
    
    
    // Function to update the user location
    func mapView(mapView: MKMapView, didUpdateUserLocation
        userLocation: MKUserLocation) {
            mapView.centerCoordinate = userLocation.location!.coordinate
            mapView.setRegion(MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate as self
        mapView.delegate = self
        // Set that it should show the user location
        mapView.showsUserLocation = true
        
        loadInitialData()

    }
    
}

