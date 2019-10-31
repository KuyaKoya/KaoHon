//
//  ProfileViewController.swift
//  KaoHon
//
//  Created by Action Trainee on 28/10/2019.
//  Copyright © 2019 Action Trainee. All rights reserved.
//

import UIKit
import MapKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var addrStreetLbl: UILabel!
    @IBOutlet weak var addrSuiteLbl: UILabel!
    @IBOutlet weak var addrCityLbl: UILabel!
    @IBOutlet weak var addrZipCodeLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!
    @IBOutlet weak var CompanyNameLbl: UILabel!
    @IBOutlet weak var CatchphraseLbl: UILabel!
    @IBOutlet weak var bsLbl: UILabel!
    @IBOutlet weak var directionsBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let geoLat = 10.281923
    let geoLng = 123.881524
    var initialLocation: CLLocation?
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    
    var profileData: NSObject?
    
    struct Home {
        var name: String
        var lattitude: CLLocationDegrees
        var longtitude: CLLocationDegrees
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImgView.image = (UIImage (named: "spiderman"))
        profileImgView.layer.cornerRadius = 60
        
//        print("profile data \(profileData as Any)")
        if profileData != nil {
            fullnameLbl.text = (profileData?.value(forKey: "name") as! String)
            usernameLbl.text = "Username: \(profileData?.value(forKey: "username") as! String)"
            emailLbl.text = "Email: \(profileData?.value(forKey: "email") as! String)"
            
            let address:NSObject? = (profileData?.value(forKey: "address") as! NSObject)
            addrStreetLbl.text = "Street: \(address!.value(forKey: "street") as! String)"
            addrSuiteLbl.text = "Suite: \(address?.value(forKey: "suite") as! String)"
            addrCityLbl.text = "City: \(address?.value(forKey: "city") as! String)"
            addrZipCodeLbl.text = "Zipcode: \(address?.value(forKey: "zipcode") as! String)"
            
//            let geo:NSObject? = (address?.value(forKey: "geo") as! NSObject)
//
//            geoLatLbl.text = "Geo Lat: \(geoLat) as! String)"
//            geoLngLbl.text = "Geo Lng: \(geoLng) as! String)"
            
            checkLocationServices()//check for permissions
            let home = [Home(name: "My Home", lattitude: geoLat, longtitude: geoLng)] //store lat, long and name to struct
            fetchHome(home) //add annotation
            
            
            phoneLbl.text = "Phone: \(profileData?.value(forKey: "phone") as! String)"
            websiteLbl.text = "Website: \(profileData?.value(forKey: "website") as! String)"
            
            let company:NSObject? = (profileData?.value(forKey: "company") as! NSObject)
            CompanyNameLbl.text = "Company Name: \(company?.value(forKey: "name") as! String)"
            CatchphraseLbl.text = "Catchphrase: \(company?.value(forKey: "catchPhrase") as! String)"
            bsLbl.text = "BS: \(company?.value(forKey: "bs") as! String)"
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
            mapView.showsUserLocation = true
        case .denied: // Show alert telling users how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .restricted: // Show an alert letting them know what’s up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func fetchHome(_ home: [Home]) {
        for myHome in home {
            let annotations = MKPointAnnotation()
            annotations.title = myHome.name
            annotations.coordinate = CLLocationCoordinate2D(latitude:
                myHome.lattitude, longitude: myHome.longtitude)
            initialLocation = CLLocation(latitude: myHome.lattitude, longitude: myHome.longtitude) //set camera position
            centerMapOnLocation(location: initialLocation!) //set camera location and zoom
            mapView.addAnnotation(annotations)
        }
    }
    
   
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let identifier = segue.identifier, identifier == "map"{
                if let vc = segue.destination as? MapViewController{
                    vc.geoLat = geoLat
                    vc.geoLng = geoLng
                }
            }
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
