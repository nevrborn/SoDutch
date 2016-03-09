//
//  MapAnnotationsExtension.swift
//  SoDutch
//
//  Created by Jarle Matland on 09.03.2016.
//  Copyright © 2016 Donkey Monkey. All rights reserved.
//

import MapKit

extension MapViewController {
    
    func loadInitialData() {
        
        for item in itemsStore.allItems {
            let title = item.itemTitle
            let coordinate = CLLocationCoordinate2DMake(item.latitude, item.longitude)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = coordinate
            annotation.title = title
            
            annotations.append(annotation)
            mapView.addAnnotations(annotations)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
        } else {
            annotationView!.annotation = annotation
            annotationView?.calloutOffset = CGPoint(x: -5, y: 5)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            annotationView!.canShowCallout = true
        }
        
        return annotationView
    }
    
    
}
