//
//  AlbumCollectionViewController.swift
//  KaoHon
//
//  Created by Action Trainee on 30/10/2019.
//  Copyright © 2019 Action Trainee. All rights reserved.
//

import UIKit

class AlbumCollectionViewController: UICollectionViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var albumData: NSObject? //from userdata
    var userAlbum: NSMutableArray = NSMutableArray() //all albums
    var userPhotos: NSMutableArray = NSMutableArray() //all photos of users
    var userThumbnails: NSMutableArray = NSMutableArray() //1st thumbnail of each album
    var albumArray: NSMutableArray = NSMutableArray() //temp array
    var id: NSMutableArray = NSMutableArray()
    var albumPhotos = [String: NSMutableArray]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "album")

        // Do any additional setup after loading the view.
    
        let session = URLSession.shared
        
        //get album task
        let albumUrl = URL(string: "https://jsonplaceholder.typicode.com/albums")!
        
        let getAlbumTask = session.dataTask(with: albumUrl, completionHandler: { data, response, error in
            
            do {
                if let json:NSArray = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                    for album in json{
                        if let object = album as? AnyObject, let ID = object.value(forKey: "userId") as? Int, ID == self.albumData?.value(forKey: "id") as? Int{
                            self.id.add(object.value(forKey: "id") as? Int as Any)
                            self.userAlbum.add(album)
                        }
                    }
                }
                
                let photosURL = URL(string: "https://jsonplaceholder.typicode.com/photos")!
                let getPhotoTask = session.dataTask(with: photosURL, completionHandler: { data, response, error in
                    do {
                        if let json:NSArray = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                            for photo in json{
                                if let object = photo as? AnyObject{
                                    if let albumid = object.value(forKey: "albumId") as? Int, self.id.contains(albumid){
                                        if let album = self.albumPhotos["\(albumid)"]{
                                            album.add(photo)
                                        }else{
                                            let tempArray = NSMutableArray(object: photo)
                                            self.albumPhotos["\(albumid)"]  = tempArray
                                        }
                                    }
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.activityIndicator.stopAnimating()
                        }
                        
                    } catch {
                        print("JSON error: \(error.localizedDescription)")
                    }
                })
                getPhotoTask.resume()
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        })
        activityIndicator.startAnimating()
        getAlbumTask.resume()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count: Int = id.count
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
    
        if let photoId = self.id.object(at: indexPath.row) as? Int, let first = self.albumPhotos["\(photoId)"]?.firstObject as? AnyObject, let url = URL(string: first.value(forKey: "url") as! String){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    cell.albumCell.image = UIImage(data: data!)
                }
            }
            cell.titleLbl.text = (userAlbum.object(at: indexPath.row) as AnyObject).value(forKey: "title") as? String
        }
        // Configure the cell
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = collectionView.indexPathsForSelectedItems{
            if let identifier = segue.identifier, identifier == "photos"{
                if let vc = segue.destination as? PhotosViewController{
                    if let first = indexPath.first?.row{
                        if let data = albumPhotos["\(first + 1)"]{
                            vc.photosArray = data
                        }
                    }
                }
            }
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
