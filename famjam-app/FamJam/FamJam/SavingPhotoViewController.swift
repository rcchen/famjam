//
//  SavingPhotoViewController.swift
//  FamJam
//
//  Created by Lucio Tan on 4/24/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import UIKit

class SavingPhotoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        savedImage.image = savedImageReference
        
        // Makes it such that screen will adjust when keyboard goes on
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        // Makes it such that tapping out of keyboard will hide it
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

    }

    

    @IBAction func savePhotoPressed(sender: UIButton) {
        //        let destination = segue.destinationViewController as? NewHomePageViewController
        //        destination?.defaultCaption = captionTextField.text
        //        destination?.savedImage = savedImageReference
        
        // Save photo to database
        AuthenticatedApiService.sharedInstance.addPhotoToTopic((AppData.ACTIVE_TOPIC?._id)!, photo: savedImageReference!, description: captionTextField.text, cb: {success in
            
            
            // Reloading topic here (so that the new photo will be included)
            AuthenticatedApiService.sharedInstance.getTopic((AppData.ACTIVE_TOPIC?._id)!)
                .onSuccess(callback: {
                    topic in
                    AppData.ACTIVE_TOPIC = topic
                    print("NEW TOPIC AFTER SAVE: ")
                    print(AppData.ACTIVE_TOPIC)
                    // Performs segue after saving
                    self.performSegueWithIdentifier("savedPhoto", sender: self)
                })
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var savedImageReference:UIImage?
    
    @IBOutlet weak var savedImage: UIImageView!
    
    @IBOutlet weak var captionTextField: UITextView!
    
    var imageData: NSData?
    
    var savedImageURL:NSURL?
    
    // Will show the keyboard
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    // Will hide the keyboard
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
