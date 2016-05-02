//
//  FrontPageViewController.swift
//  FamJam
//
//  Created by Lucio Tan on 4/23/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import UIKit

class FrontPageViewController: UIViewController {

    @IBOutlet weak var systemMessageLabel: UILabel!
    
    var keyBoardShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Makes it such that screen will adjust when keyboard goes on
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
    
    @IBAction func unwindWithLogout(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindWithCancelNewUser(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindWithNewUserCreated(segue: UIStoryboardSegue) {
        
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

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginPressed(sender: UIButton) {
        
        print("login pressed")
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        AnonymousApiService.authenticateUser(username, password: password)
            .onSuccess { valid in
                print("Is valid")
                
                let authenticatedService = AuthenticatedApiService.sharedInstance
                
                authenticatedService.setHeaders()
                
                authenticatedService.getMe()
                    .onSuccess { user in
                        AppData.ACTIVE_USER = user
                        authenticatedService.getFamily(user.families![0]._id!)
                            .onSuccess { family in
                                AppData.ACTIVE_FAMILY = family
                                // TODO: NEED TO GET RID OF THIS!!!
                                authenticatedService.createTopic("Time Flies")
                                    .onSuccess(callback: {
                                        topic in
                                        AppData.ACTIVE_TOPIC = topic
                                        self.performSegueWithIdentifier("loginUser", sender: self)
                                    })
                                
                        }
                }
        }
        
//        AnonymousApiService.authenticateUser(usernameTextField.text!, password: passwordTextField.text!, cb: {(valid:Bool) in
//            if (valid) {
//
//                
//                
//                
//            } else {
//                print("Not valid")
//                self.systemMessageLabel.text = "Invalid username/password combination."
//            }
//        })
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
