//
//  NewPhotoViewController.swift
//  FamJam
//
//  Created by Roger Chen on 5/8/16.
//  Copyright © 2016 Famjam. All rights reserved.
//

import FDTake
import Foundation
import UIKit

class NewPhotoViewController: UIViewController {
    var fdTakeController = FDTakeController()
    var selectedImage: UIImage!
    var topicId: String!
    
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var descriptionField: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeFdTakeController()
    }
    
    @IBAction func selectPhoto(sender: AnyObject) {
        fdTakeController.present()
    }

    @IBAction func submitPhoto(sender: UIButton) {
        let description = self.descriptionField.text
        let service = AuthenticatedApiService.sharedInstance
        service.addPhotoToTopic(self.topicId, photo: self.selectedImage, description: description)
        .then { success -> Void in
            if (success) {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                // figure out error state here if image could not be submitted
            }
        }
        
    }

    func addImageToView(image: UIImage) {
        let imageView = UIImageView(frame: photoContainerView.bounds)
        imageView.image = image
        photoContainerView.insertSubview(imageView, atIndex: photoContainerView.subviews.count)
    }

    func initializeFdTakeController() {
        fdTakeController.allowsEditing = true
        fdTakeController.allowsVideo = false
        fdTakeController.didGetPhoto = {(photo: UIImage, info: [NSObject : AnyObject]) -> Void in
            self.selectedImage = photo
            self.addImageToView(photo)
        }
    }
}
