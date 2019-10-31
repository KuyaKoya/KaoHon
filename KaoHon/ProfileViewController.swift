//
//  ProfileViewController.swift
//  KaoHon
//
//  Created by Action Trainee on 28/10/2019.
//  Copyright © 2019 Action Trainee. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var addrStreetLbl: UILabel!
    @IBOutlet weak var addrSuiteLbl: UILabel!
    @IBOutlet weak var addrCityLbl: UILabel!
    @IBOutlet weak var addrZipCodeLbl: UILabel!
    @IBOutlet weak var geoLatLbl: UILabel!
    @IBOutlet weak var geoLngLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!
    @IBOutlet weak var CompanyNameLbl: UILabel!
    @IBOutlet weak var CatchphraseLbl: UILabel!
    @IBOutlet weak var bsLbl: UILabel!
    
    var profileData: NSObject?
    
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
            
            let geo:NSObject? = (address?.value(forKey: "geo") as! NSObject)
            geoLatLbl.text = "Geo Lat: \(geo?.value(forKey: "lat") as! String)"
            geoLngLbl.text = "Geo Lng: \(geo?.value(forKey: "lng") as! String)"
            
            phoneLbl.text = "Phone: \(profileData?.value(forKey: "phone") as! String)"
            websiteLbl.text = "Website: \(profileData?.value(forKey: "website") as! String)"
            
            let company:NSObject? = (profileData?.value(forKey: "company") as! NSObject)
            CompanyNameLbl.text = "Company Name: \(company?.value(forKey: "name") as! String)"
            CatchphraseLbl.text = "Catchphrase: \(company?.value(forKey: "catchPhrase") as! String)"
            bsLbl.text = "BS: \(company?.value(forKey: "bs") as! String)"
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
