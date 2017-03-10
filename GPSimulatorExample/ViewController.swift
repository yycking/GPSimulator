//
//  ViewController.swift
//  GPSimulatorExample
//
//  Created by Wayne Yeh on 2017/3/9.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    let locationManager = CLLocationManager()
    var preCoordinate: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let coordinate = preCoordinate {
            let line = MKPolyline(coordinates: [coordinate, userLocation.coordinate], count: 2)
            mapView.add(line)
        }
        preCoordinate = userLocation.coordinate
        
        mapView.userTrackingMode = .follow
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor.red
            return lineView
        }
        
        return MKOverlayRenderer()
    }
}

