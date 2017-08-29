//
//  ViewController.swift
//  mapsdemo
//
//  Created by Sriteja Thuraka on 5/15/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    //14501 Sweitzer Lane Laurel, Maryland 20707
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let geoCoding = CLGeocoder()
    let adress = "14501 Sweitzer Lane, Laurel, Maryland 20707"

    var currentPlacemark: CLPlacemark?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userLocation()
        geoCoderFunction()
        showDirection()
        mapView.showsTraffic = true
    }
    
    func userLocation () {
        
        
        locationManager.requestWhenInUseAuthorization()
         let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            
            mapView.showsUserLocation = true
    }
        
    }
    
    func geoCoderFunction() {
        
        geoCoding.geocodeAddressString(adress) { (placemarks, error) in
            if error != nil {
                
                print(error)
                return
            }
            if let placemarks = placemarks {
                
                let placemark = placemarks[0]
                self.currentPlacemark = placemark
                
                let annotation = MKPointAnnotation()
                annotation.title = "Collegepark"
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                    
                }
                
            }
        }
        
    }
    
    func showDirection() {
        
        guard let currentPlacemark = currentPlacemark else {
            
            return
        }
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        let direction = MKDirections(request: directionRequest)
        direction.calculate { (routeResponse, routeError) in
            guard let routeResponse = routeResponse else {
                if let routeError = routeError {
                    print(routeError)
                }
                return
            }
            let route = routeResponse.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 3.0
        return renderer
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

