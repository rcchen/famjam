//
//  NewUserViewController.swift
//  FamJam
//
//  Created by Lucio Tan on 4/28/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import PromiseKit
import UIKit

class NewUserViewController: UIViewController {

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
//        if (segue.identifier == "newUserCreated") {
//            AnonymousApiService.createUser(usernameTextField.text!, password: passwordTextField.text!, displayName: displaynameTextField.text!, cb: {})
//            
//        }
        
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {

        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let displayName = displaynameTextField.text!
        let familyName = familyTextField.text!

        let authenticatedService = AuthenticatedApiService.sharedInstance
        firstly { () -> Promise<Void> in
            AnonymousApiService.createUser(username, password: password, displayName: displayName)
        }.then { () -> Promise<Void> in
            return AnonymousApiService.authenticateUser(username, password: password)
        .then { () -> Promise<Family> in
            authenticatedService.setHeaders()
            return AuthenticatedApiService.sharedInstance.joinOrCreateFamily(familyName)
        }.then { family -> Promise<User> in
            return authenticatedService.getMe()
        }.then { user -> Promise<[Family]> in
            AppData.ACTIVE_USER = user
            return authenticatedService.getMeFamilies()
        }.then { families -> Promise<[Topic]> in
            AppData.ACTIVE_FAMILY = families[0]
            return authenticatedService.getTopics(nil)
        }.then { topics -> Promise<[User]> in
            //AppDataFunctions.addTopicsToAllTopicsArray(topics)
            AppData.ALL_TOPICS = topics
            return authenticatedService.getFamilyMembers((AppData.ACTIVE_FAMILY?._id)!)
        }.then { familyMembers -> Void in
            AppData.ACTIVE_FAMILY_MEMBERS = familyMembers
            self.performSegueWithIdentifier("newUserCreated", sender: self)
        }
    }
    
    
    }
    
    var keyBoardShowing = false
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    @IBOutlet weak var displaynameTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!

    
    @IBOutlet weak var familyTextField: UITextField!
    
    
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
