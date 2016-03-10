//
//  MapAnnotationsExtension.swift
//  SoDutch
//
//  Created by Jarle Matland on 09.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import MapKit

extension MapViewController {
    
    // Creates a pin for all items in allItems[]
    func loadInitialData() {
        
        for item in itemsStore.allItems {
            let title = item.itemTitle
            
            let annotation = MKPointAnnotation()
            
            let coordinate = CLLocationCoordinate2DMake(item.latitude, item.longitude)
            
            annotation.coordinate = coordinate
            annotation.title = title
            
            annotations.append(annotation)
            mapView.addAnnotations(annotations)
        }
    }
    
    // Edits the pin configuration
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "pin"
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pin!.calloutOffset = CGPoint(x: -5, y: 5)
            pin!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            pin!.canShowCallout = true
        } else {
            pin!.annotation = annotation

        }
        
        return pin
    }
    
    // When info button is tapped on pin, go to ItemViewController
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            
       // tabBarController!.transitionFromViewController((tabBarController?.viewControllers![0])!, toViewController: (tabBarController?.viewControllers![2])!, duration: 0.2, options: .TransitionFlipFromRight, animations: nil, completion: )

        }
    }
    
}
