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
    var userPostId: NSMutableArray = NSMutableArray()
    var userComment: NSMutableArray = NSMutableArray()
    var postAndCommentArray: NSMutableArray = NSMutableArray()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var addTitlePost: UITextField!
    @IBOutlet weak var addDescriptionPost: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let session = URLSession.shared
        let urlPost = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        let postTask = session.dataTask(with: urlPost, completionHandler: { data, response, error in
            do {
                if let json:NSArray = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                    for post in json{
                        if let object = post as? AnyObject, let ID = object.value(forKey: "userId") as? Int, ID == self.postData?.value(forKey: "id") as? Int{
                            self.postAndCommentArray.add(post)
                            if let id = object.value(forKey: "id") as? Int{
                                let urlComments = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(id)")!
                                let taskComments = session.dataTask(with: urlComments, completionHandler: { data, response, error in
                                    do {
                                        if let json:NSArray = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                                            for comment in json{
                                                self.postAndCommentArray.insert(comment, at: self.postAndCommentArray.index(of: object)+1)
                                            }
                                        }
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                        }
                                    } catch {
                                        print("JSON error: \(error.localizedDescription)")
                                    }
                                    
                                })
                                taskComments.resume()
                            }
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
        postTask.resume()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postAndCommentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (postAndCommentArray.object(at: indexPath.row) as AnyObject).value(forKey: "email") != nil{
            let comment: CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "comments", for: indexPath) as! CommentTableViewCell
            comment.commentLbl.text = (postAndCommentArray.object(at: indexPath.row) as AnyObject).value(forKey: "body") as? String
            return comment
        }
        
        else{
            let post: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! PostTableViewCell
            post.titleLbl.text = (postAndCommentArray.object(at: indexPath.row) as AnyObject).value(forKey: "title") as? String
            post.postLbl.text = (postAndCommentArray.object(at: indexPath.row) as AnyObject).value(forKey: "body") as? String
            
            return post
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       return 250
        
    }

    @IBAction func postButton(_ sender: Any) {
        
        // prepare json data
        let addObject = ["title" : addTitlePost.text, "body" : addDescriptionPost.text]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: addObject)
        
        // create post request
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                
                self.postAndCommentArray.insert(addObject, at: 0)
                

            }
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.automatic)
                self.tableView.endUpdates()
                self.tableView.reloadData()
            }
        }
        
        task.resume()
    }
}
