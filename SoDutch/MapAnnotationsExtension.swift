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
            let itemsKey = item.itemKey
            
            let annotation = MKPointAnnotation()
            
            let coordinate = CLLocationCoordinate2DMake(item.latitude, item.longitude)
            
            if coordinate.latitude != mapView.userLocation.coordinate.latitude && coordinate.longitude != mapView.userLocation.coordinate.longitude {
                
                annotation.coordinate = coordinate
                annotation.title = title
                annotation.subtitle = itemsKey
                
                annotations.append(annotation)
            }
            mapView.addAnnotations(annotations)
        }
    }
    
    // Edits the pin configuration
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        let reuseIdentifier = "pin"
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        
        if annotation.coordinate.latitude != mapView.userLocation.coordinate.latitude && annotation.coordinate.longitude != mapView.userLocation.coordinate.longitude {
            
            if pin == nil {
                pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                
            } else {
                pin!.annotation = annotation
                
            }
        }
        
        return pin
    }
    
    // When info button is tapped on pin, go to ItemViewController
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            
            tabBarController?.selectedIndex = 2
            
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if routeOverlay != nil {
            self.mapView.removeOverlay(routeOverlay!)
        }
        
        var i = 0
        itemKeyString = ""
        let itemKeyStringWrapped = view.annotation!.subtitle
        
        if view.annotation?.coordinate.latitude != mapView.userLocation.coordinate.latitude && view.annotation?.coordinate.longitude != mapView.userLocation.coordinate.longitude {
            
            if itemKeyStringWrapped != nil {
                itemKeyString = (itemKeyStringWrapped!?.uppercaseString)!
            }
            
            
            while i < itemsStore.allItems.count {
                
                if itemKeyString == itemsStore.allItems[i].itemKey {
                    let item = itemsStore.allItems[i]
                    annotationDetailView.hidden = false
                    imagePlaceholderView.hidden = false
                    linkView.hidden = false
                    let coordinate = CLLocation(latitude: item.latitude, longitude: item.longitude)
                    imageView.image = item.editedImage
                    titleLabel.text = item.itemTitle
                    
                    var distanceItem = Int(distanceToItem(coordinate))
                    
                    if distanceItem < 1000 {
                        distanceLabel.text = String(distanceItem)
                        meterKmLabel.text = "meters away"
                    } else {
                        distanceItem = distanceItem / 1000
                        distanceLabel.text = String(distanceItem)
                        meterKmLabel.text = "km away"
                    }
                    
                    let destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(item.latitude, item.longitude), addressDictionary: nil)
                    destination = MKMapItem(placemark: destinationPlacemark)
                    
                    mapView.setCenterCoordinate((view.annotation?.coordinate)!, animated: true)
                    
                    i = itemsStore.allItems.count
                } else {
                    i++
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        annotationDetailView.hidden = true
        imagePlaceholderView.hidden = true
        linkView.hidden = true
        
    }
    
    
    
}
