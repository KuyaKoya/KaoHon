//
//  MapViewController.swift
//  KaoHon
//
//  Created by Action Trainee on 31/10/2019.
//  Copyright © 2019 Action Trainee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {

    var geoLat: Double?
    var geoLng: Double?
    var locationManager = CLLocationManager()

    @IBOutlet weak var fullMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkLocationServices()//check for permissions
        fetchHome() //add annotation
        
//        self.locationManager.requestAlwaysAuthorization()
//
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
//        }
//
//        fullMapView.delegate = self
//        fullMapView.mapType = .standard
//        fullMapView.isZoomEnabled = true
//        fullMapView.isScrollEnabled = true
//
//        if let coor = fullMapView.userLocation.location?.coordinate{
//            fullMapView.setCenter(coor, animated: true)
//        }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 10.30, longitude: 123.881524), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: geoLat!, longitude: geoLng!), addressDictionary: nil))
        print(request.source as Any)
        print(request.destination as Any)
        request.requestsAlternateRoutes = true
        request.transportType = .any

        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }

            for route in unwrappedResponse.routes {
                self.fullMapView.addOverlay(route.polyline)
                self.fullMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            fullMapView.showsUserLocation = true
        case .denied: // Show alert telling users how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            fullMapView.showsUserLocation = true
        case .restricted: // Show an alert letting them know what’s up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func fetchHome() {
        let annotations = MKPointAnnotation()
        annotations.title = "Home"
        annotations.coordinate = CLLocationCoordinate2D(latitude:
            geoLat!, longitude: geoLng!)
        print(annotations.coordinate)
        fullMapView.addAnnotation(annotations)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        fullMapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        fullMapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "My Location"
        annotation.subtitle = "current location"
        fullMapView.addAnnotation(annotation)
        
        //centerMap(locValue)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
