//
//  ViewController.swift
//  KaoHon
//
//  Created by Action Trainee on 28/10/2019.
//  Copyright © 2019 Action Trainee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var userArray: NSArray?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let session = URLSession.shared
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            
            do {
                let json:NSArray = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                self.userArray = json
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.activityIndicator.stopAnimating()
            }
            
        })
        self.activityIndicator.startAnimating()
        task.resume()
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: Int = userArray?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell

        if userArray?.firstObject != nil {
            cell.fullnameLbl.text = (userArray?.object(at: indexPath.row) as AnyObject).value(forKey: "name") as? String
            cell.emailLbl.text = (userArray?.object(at: indexPath.row) as AnyObject).value(forKey: "email") as? String
            cell.profileImage.image = UIImage (named: "spiderman")
            cell.profileImage.layer.cornerRadius = 40
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "profileview") as! TabViewController
        
        if let data = self.userArray?.object(at: indexPath.row) as? NSObject{
            (vc.viewControllers?[0] as? ProfileViewController)?.profileData = data
            (vc.viewControllers?[1] as? PostViewController)?.postData = data
            (vc.viewControllers?[2] as? AlbumCollectionViewController)?.albumData = data
        }
        
//        self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let indexPath = self.tableview.indexPathForSelectedRow{
//            if let identifier = segue.identifier, identifier == "profileSegue"{
//                if let vc = segue.destination as? TabViewController{
//                    if let data = self.userArray?.object(at: indexPath.row) as? NSObject{
//                        (vc.viewControllers?[0] as? ProfileViewController)?.profileData = data
//                        (vc.viewControllers?[1] as? PostViewController)?.postData = data
//                        (vc.viewControllers?[2] as? AlbumCollectionViewController)?.albumData = data
//                    }
//                }
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

