//
//  PostViewController.swift
//  KaoHon
//
//  Created by Action Trainee on 28/10/2019.
//  Copyright © 2019 Action Trainee. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var postData: NSObject?
    var userPost: NSMutableArray = NSMutableArray()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let session = URLSession.shared
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            
            do {
                if let json:NSArray = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                    for post in json{
                        if let object = post as? AnyObject, let ID = object.value(forKey: "userId") as? Int, ID == self.postData?.value(forKey: "id") as? Int{
                            self.userPost.add(post)
                        }
                    }
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.postTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            
        })
        activityIndicator.startAnimating()
        task.resume()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: Int = userPost.count 
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! PostTableViewCell
        
        
        
        if userPost.firstObject != nil {
            print(postData as Any)
            post.titleLbl.text = (userPost.object(at: indexPath.row) as AnyObject).value(forKey: "title") as? String
            post.postLbl.text = (userPost.object(at: indexPath.row) as AnyObject).value(forKey: "body") as? String
        }else{
            post.titleLbl.text = "hello"
        }
        
        
        return post
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

}
