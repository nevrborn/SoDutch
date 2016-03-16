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
    
    @IBOutlet var linkView: UIView!
    @IBOutlet var annotationDetailView: UIView!
    @IBOutlet var imagePlaceholderView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var updateLocationButton: UIButton!
    
    var location: CLLocation!
    var locationManager: CLLocationManager!
    var window: UIWindow!
    var annotations = [MKPointAnnotation]()
    var firstLoadOfMap = true
    var destination: MKMapItem?
    var itemTitleFromDetailView: String?
    var comingFromDetailView: Bool = false
    var routeOverlay: MKOverlay?
    
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
        
        routeToItem()
        
        annotationDetailView.hidden = true
        imagePlaceholderView.hidden = true
        
    }
    
    
    @IBAction func openInAppleMaps(sender: UIButton) {
        
    }
    
    @IBAction func showDetailView(sender: UIButton) {
        
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
    
    func routeToItem() {
        
        let directionRequest = MKDirectionsRequest()
        
        directionRequest.source = MKMapItem.mapItemForCurrentLocation()
        directionRequest.destination = destination
        
        directionRequest.requestsAlternateRoutes = true
        
        directionRequest.transportType = .Walking
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculateDirectionsWithCompletionHandler ({(response:
            MKDirectionsResponse?, error: NSError?) in
            
            if error == nil {
                for route in response!.routes {
                    
                    self.mapView.addOverlay(route.polyline,
                        level: MKOverlayLevel.AboveRoads)
                    
                    self.routeOverlay = route.polyline
                }
                
            } else {
                
                let alertController = UIAlertController(title: "Not possible to find directions for this item", message: "Please select a different pin", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "OK", style: .Destructive, handler: nil)
                
                alertController.addAction(okAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor()
        return renderer
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
        imagePlaceholderView.hidden = true
        linkView.hidden = true
        
    }
    
    // Will reload all annotation when the view appears again
    override func viewWillAppear(animated: Bool) {
        loadInitialData()
        
        var i = 0
        var selectedAnnotation: MKAnnotation?
        
        if comingFromDetailView == true {
            
            while i < annotations.count {
                if annotations[i].title == itemTitleFromDetailView {
                    selectedAnnotation = annotations[i]

                    mapView.selectAnnotation(selectedAnnotation!, animated: true)
                    
                    annotationDetailView.hidden = false
                    imagePlaceholderView.hidden = false
                    linkView.hidden = false
                    comingFromDetailView = false
                    break
                }
                
                i++
            }
        } else {
            annotationDetailView.hidden = true
            imagePlaceholderView.hidden = true
            linkView.hidden = true
        }
    }
    
}

