//
//  NewTopicViewController.swift
//  FamJam
//
//  Created by Lucio Tan on 4/29/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import PromiseKit
import UIKit

class NewTopicViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        // Makes it such that tapping out of keyboard will hide it
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "savedTopic") {
//            print(newTopicTextField.text)
//        }
    }
    
    var keyBoardShowing = false
    
    @IBOutlet weak var newTopicTextField: UITextField!
    
    @IBAction func saveTopicPressed(sender: UIBarButtonItem) {

        let authenticatedService = AuthenticatedApiService.sharedInstance
        firstly { () -> Promise<Topic> in
            authenticatedService.createTopic(newTopicTextField.text!)
        }.then { topic -> Promise<[Topic]> in
            AppData.ACTIVE_TOPIC = topic
            return authenticatedService.getTopics(true)
        }.then { topics -> Void in
            for topic in topics {
                let topicCopy = topic
                if (topicCopy._id != AppData.ACTIVE_TOPIC?._id) {
                    topicCopy.active = false
                    authenticatedService.updateTopic(topicCopy)
                    .then { topic -> Void in
                        self.performSegueWithIdentifier("savedTopic", sender: self)
                    }
                }
            }
        }

    }
    
    // Will show the keyboard
    func keyboardWillShow(notification: NSNotification) {
        
        if (!keyBoardShowing) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y -= keyboardSize.height
            }
            
            keyBoardShowing = true
        }
    }
    
    // Will hide the keyboard
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
        keyBoardShowing = false
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
