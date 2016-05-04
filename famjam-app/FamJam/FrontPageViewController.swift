//
//  FrontPageViewController.swift
//  FamJam
//
//  Created by Lucio Tan on 4/23/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import PromiseKit
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
        
        let authenticatedService = AuthenticatedApiService.sharedInstance
        let username = usernameTextField.text!
        let password = passwordTextField.text!

        firstly { () -> Promise<Void> in
            AnonymousApiService.authenticateUser(username, password: password)
        }.then { () -> Promise<User> in
            authenticatedService.setHeaders()
            return authenticatedService.getMe()
        }.then { user -> Promise<[Family]> in
            AppData.ACTIVE_USER = user
            return authenticatedService.getMeFamilies()
        }.then { families -> Promise<[User]> in
            AppData.ACTIVE_FAMILY = families[0]
            return authenticatedService.getFamilyMembers(AppData.ACTIVE_FAMILY!._id!)
        } .then { familyMembers -> Promise<[Topic]> in
            AppData.ACTIVE_FAMILY_MEMBERS = familyMembers
            return authenticatedService.getTopics(true)
        }.then { topics -> Promise<Topic> in
            AppData.ACTIVE_TOPIC = topics[0]
            
            // Debug statements
            print("Active user: " + (AppData.ACTIVE_USER?.username)!)
            
            print("Active family members: " + (AppData.ACTIVE_FAMILY?.attributes!["displayName"])!)
            
            print("Active topic: " + (AppData.ACTIVE_TOPIC?.name)!)
            print("Active topic (old) images: ")
            print((AppData.ACTIVE_TOPIC?.images))

            return authenticatedService.getTopic((AppData.ACTIVE_TOPIC?._id)!)
            }.then { topic -> Promise<[Topic]> in
                
                // Refetching topic because of bug (TODO: UNDO THIS WHEN IT WORKS!)
                AppData.ACTIVE_TOPIC = topic
                
                return authenticatedService.getTopics(nil)
        
        
        
        }.then { topics -> Void in
            AppData.ALL_TOPICS = topics
            
            self.performSegueWithIdentifier("loginUser", sender: self)
        }

        
        
        
        // HACKHACK
//        AnonymousApiService.authenticateUser(username, password: password)
//            .onSuccess { valid in
//                print("Is valid")
//                
//                let authenticatedService = AuthenticatedApiService.sharedInstance
//                
//                authenticatedService.setHeaders()
//                
//                authenticatedService.getMe()
//                    .onSuccess { user in
//                        AppData.ACTIVE_USER = user
//                        print("Setting active user when logging in: ")
//                        print(AppData.ACTIVE_USER)
//                        authenticatedService.getMeFamilies()
//                            .onSuccess { families in
//                                AppData.ACTIVE_FAMILY = families[0]
//                                print("Setting active family when logging in: ")
//                                print(AppData.ACTIVE_FAMILY)
//                                authenticatedService.getTopics(true)
//                                    .onSuccess(callback: {
//                                        topics in
//                                        AppData.ACTIVE_TOPIC = topics[0]
//                                        print("Setting active topic when logging in: ")
//                                        print(AppData.ACTIVE_TOPIC)
//                                        print("Adding these ACTIVE topics when logging in: ")
//                                        print(topics)
//                                        AppDataFunctions.addTopicsToAllTopicsArray(topics)
//                                        
//                                        authenticatedService.getTopics(false)
//                                            .onSuccess(callback: {
//                                                topics in
//                                                print("Adding these INACTIVE topics when logging in: ")
//                                                print(topics)
//                                                AppDataFunctions.addTopicsToAllTopicsArray(topics)
//                                                print("All active topics when logging in: ")
//                                                print(AppData.ALL_TOPICS)
//                                                self.performSegueWithIdentifier("loginUser", sender: self)
//                                            })
//                                        })
//                                    .onFailure(callback: {
//                                        error in
//                                        print("Error: ")
//                                        print(error)
//                                    })
//                                
//                        }
//                }
//        }
        
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
