//
//  PhotosViewController.swift
//  KaoHon
//
//  Created by Action Trainee on 30/10/2019.
//  Copyright © 2019 Action Trainee. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UIScrollViewDelegate{

    var photosArray: NSArray = NSArray()
    var slides:[Slide] = [];
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        check data
//        if photosArray != nil{
//            print(photosArray)
//            print(photosArray.count)
//        }
        
        scrollView.delegate = self
        
        createSlide()
//        setupSlideScrollView(slides: slides)

        // Do any additional setup after loading the view.
    }

    func createSlide(){
        let slideArray: NSMutableArray = NSMutableArray()
        var i = 0
        
        
        for pics in photosArray{
            if let photo = (pics as AnyObject).value(forKey: "url") as? AnyObject, let url = URL(string: photo as! String){
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        let slide:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
                        slide.photoView.image = UIImage(data: data!)
                        slideArray.add(slide)
                        self.scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(50), height: self.scrollView.frame.height)
                        self.scrollView.isPagingEnabled = true
                        slide.frame = CGRect(x: self.view.frame.width * CGFloat(i), y: 0, width: self.view.frame.width, height: self.scrollView.frame.height)
                        self.scrollView.addSubview(slide)
                        i = i + 1
                        self.pageControl.numberOfPages = slideArray.count
                        self.pageControl.currentPage = 0
                        self.view.bringSubviewToFront(self.pageControl)
                    }
                }
            }
        }
    }
    
//    func setupSlideScrollView(slides : [Slide]) {
//        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
//        scrollView.isPagingEnabled = true
//
//        for i in 0 ..< slides.count {
//            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: scrollView.frame.height)
//            scrollView.addSubview(slides[i])
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
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


