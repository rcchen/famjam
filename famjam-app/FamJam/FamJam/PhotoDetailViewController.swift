//
//  PhotoDetailViewController.swift
//  FamJam
//
//  Created by Lucio Tan on 4/23/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import UIKit

/*
 *  We need to use the UIScrollViewDelegate to support zooming.
 */

class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let minZoomScale = 0.2
    let maxZoomScale = 5.0
   
    
    
    @IBOutlet weak var zoomedImage: UIScrollView! {
        didSet {
            // Adding imageView as the image for the ScrollView
            zoomedImage.addSubview(imageView)
            
            // Scaling image to subview
            imageView.sizeToFit()
            imageView.contentMode = .ScaleAspectFill
            zoomedImage.contentSize = imageView.frame.size
            
            // Declaring zoomedImage's delegate to this controller
            // This controller will assist zoomedImage in zooming in
            zoomedImage.delegate = self
            
            // Setting the min and max zoom scales
            zoomedImage.minimumZoomScale = CGFloat(minZoomScale)
            zoomedImage.maximumZoomScale = CGFloat(maxZoomScale)
        }
    }
    
    var imageView = UIImageView()
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
