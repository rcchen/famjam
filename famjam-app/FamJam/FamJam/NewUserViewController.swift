//
//  NewUserViewController.swift
//  FamJam
//
//  Created by Lucio Tan on 4/28/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

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
        
        if (segue.identifier == "newUserCreated") {
            AnonymousApiService.createUser(usernameTextField.text!, password: passwordTextField.text!, displayName: displaynameTextField.text!, cb: {})
            
            
            AnonymousApiService.authenticateUser(usernameTextField.text!, password: passwordTextField.text!, cb: {(success: Bool) in
                    AuthenticatedApiService.sharedInstance.setHeaders()
                })
            
            
            
            // Joins family
            
            AuthenticatedApiService.sharedInstance.getFamilyByDisplayName(familyTextField.text!, cb: {(family: Family?) in
                if let familyToJoin = family {
                    print("family found")
                    AuthenticatedApiService.sharedInstance.joinFamily(familyToJoin._id!, cb: {_ in })
                } else {
                    print("no family found")
                    AuthenticatedApiService.sharedInstance.createFamily(self.familyTextField.text!, cb: {(successfullyCreated: Bool) in
                        print("family successfully created")
                        AuthenticatedApiService.sharedInstance.getFamilyByDisplayName(self.familyTextField.text!, cb: {(family: Family?) in
                            
                            if let familyCreated = family {
                                AuthenticatedApiService.sharedInstance.joinFamily(familyCreated._id!, cb: {_ in
                                print("successfully created and then joined")})
                            }
                        
                        })
                        
                        
                    })
                }
                })
            
            
            AppData.ACTIVE_USER = self.usernameTextField.text!
            AppData.ACTIVE_FAMILY = self.familyTextField.text!
            
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
