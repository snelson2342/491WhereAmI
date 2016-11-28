//
//  ViewController.swift
//  WhereAmI
//
//  Created by Sam N on 10/28/16.
//  Copyright © 2016 Sam N. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var prevoiusPoint: CLLocation?
    private var totalyMovementDistance = CLLocationDistance(0)
    
    @IBOutlet var mapView:MKMapView!
    
    @IBOutlet var latitudeLabel:UILabel!
    @IBOutlet var longitudeLabel:UILabel!
    @IBOutlet var horizontalAccuracyLabel:UILabel!
    @IBOutlet var altitudeLabel:UILabel!
    @IBOutlet var verticalAccuracyLabel:UILabel!
    @IBOutlet var distanceTraveledLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        switch status{
        case .Authorized, .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            mapView.mapType = MKMapType.Satellite
        default:
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let errorType = error.code == CLError.Denied.rawValue ? "Access Denied": "Error \(error.code)"
        let alertController = UIAlertController(title: "Location Manager Error", message: errorType, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { action in })
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            let latitudeString = String(format: "%g\u{00B0}", newLocation.coordinate.latitude)
            latitudeLabel.text = latitudeString
            
            let longitudeString = String(format: "%g\u{00B0}", newLocation.coordinate.longitude)
            longitudeLabel.text = longitudeString
            
            let horizontalAcuracyString = String(format:"%gm", newLocation.horizontalAccuracy)
            horizontalAccuracyLabel.text = horizontalAcuracyString
            
            let altitudeString = String(format:"%gm", newLocation.altitude)
            altitudeLabel.text = altitudeString
            
            let verticalAcuracyString = String(format:"%gm", newLocation.verticalAccuracy)
            verticalAccuracyLabel.text = verticalAcuracyString
            
            if newLocation.horizontalAccuracy < 0 {
                //invalid acuracy
                return
            }
            
            if newLocation.horizontalAccuracy > 100 || newLocation.verticalAccuracy > 50 {
                //acuracy is shit
                return
            }
            
            if prevoiusPoint == nil {
                totalyMovementDistance = 0
                let start = Place(title: "Start Point", subtitle: "This is where we started", coordinate: newLocation.coordinate)
                mapView.addAnnotation(start)
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 100, 100)
                mapView.setRegion(region, animated: true)
            }else{
                print("Movement distance: " + "\(newLocation.distanceFromLocation(prevoiusPoint!))")
                totalyMovementDistance += newLocation.distanceFromLocation(prevoiusPoint!)
            }
            prevoiusPoint = newLocation
            let distanceString = String(format:"%gm", totalyMovementDistance)
            distanceTraveledLabel.text = distanceString
        }
    }


}

