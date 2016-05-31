//
//  NewPhotoViewController.swift
//  FamJam
//
//  Created by Roger Chen on 5/8/16.
//  Copyright © 2016 Famjam. All rights reserved.
//

import FDTake
import Flurry_iOS_SDK
import Foundation
import UIKit

class NewPhotoViewController: UIViewController, UITextViewDelegate {
    var fdTakeController = FDTakeController()
    var selectedImage: UIImage!
    var topicId: String!

    var PLACEHOLDER = "Enter a description here..."
    
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeFdTakeController()
        self.submitButton.enabled = false
        self.submitButton.backgroundColor = UIColor(rgba: "#81D4FA")
        self.submitButton.titleLabel?.text = "Add a photo first"
        self.descriptionField.text = PLACEHOLDER
        self.descriptionField.textColor = UIColor.lightGrayColor()
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
                Flurry.logEvent("PHOTO_SUBMITTED", withParameters: Utilities.getFlurryParameters())
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
            self.submitButton.enabled = true
            self.submitButton.backgroundColor = UIColor(rgba: "#039BE5")
            self.submitButton.titleLabel?.text = "Submit photo"
        }
    }

    func textViewDidBeginEditing(textView: UITextView) {
        print("hurr");
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }

    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = PLACEHOLDER
            textView.textColor = UIColor.lightGrayColor()
        }
    }
}
