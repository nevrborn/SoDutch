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
    
    
    @IBOutlet var annotationDetailView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var updateLocationButton: UIButton!
    
    var location: CLLocation!
    var locationManager: CLLocationManager!
    var window: UIWindow!
    var annotations = [MKPointAnnotation]()
    var firstLoadOfMap = true
    
    var itemsStore: ItemsStore!
    var imageStore: ImageStore!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var mapSegment: UISegmentedControl!
    
    // If pressing "ARROW" then the location will be zoomed in to users location
    @IBAction func goToCurrentLocation(sender: UIButton) {
        self.mapView.showsUserLocation = true
        mapView.setRegion(MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }
    
    @IBAction func getRouteToItem(sender: UIButton) {
        
        
        
    }
    
    
    
    // Segmented controll to display Standard, Hybrid or Satelite
    @IBAction func mapTypeSegment(sender: UISegmentedControl) {
        
        let segmentedControl = sender
        segmentedControl.addTarget(self, action: "mapTypeChanged:", forControlEvents: .ValueChanged)
        
    }
    
    // Segmented control for map
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
    
    func routeToMapItem() {

        let directionRequest: MKDirectionsRequest = MKDirectionsRequest()
        
        directionRequest.source = MKMapItem.mapItemForCurrentLocation()
        directionRequest.destination = MKMapItem.

        directionRequest.requestsAlternateRoutes = true

        directionRequest.transportType = .Walking

        let directions = MKDirections(request: directionRequest)
        
        directions.calculateDirectionsWithCompletionHandler ({
            (response: MKDirectionsResponse?, error: NSError?) in
            if let routeResponse = response?.routes {
                
            } else if let _ = error {
                
            }
        })
    }
    
    // Segmented controll to display ALL or RECENT photos
    @IBAction func itemsViewSegment(sender: UISegmentedControl) {
        
    }
    
    
    // Function to update the user location
    func mapView(mapView: MKMapView, didUpdateUserLocation
        userLocation: MKUserLocation) {
            
            if firstLoadOfMap == true {
                mapView.setRegion(MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
                firstLoadOfMap = false
            }
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate as self
        mapView.delegate = self
        // Set that it should show the user location
        mapView.showsUserLocation = true
        
        loadInitialData()
        
        annotationDetailView.hidden = true
        
    }
    
    // Will reload all annotation when the view appears again
    override func viewWillAppear(animated: Bool) {
        loadInitialData()
        
        annotationDetailView.hidden = true
    }
    
}

