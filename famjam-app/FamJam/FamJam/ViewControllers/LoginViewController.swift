//
//  FrontPageViewController.swift
//  FamJam
//
//  Created by Lucio Tan on 4/23/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import PromiseKit
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var systemMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginPressed(sender: UIButton) {

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
            
        }.then { topics -> Promise<[Topic]> in
            if (topics.count == 0) {
                AppData.ACTIVE_TOPIC = nil
                //print("reaching here")
                //self.performSegueWithIdentifier("loginUser", sender: self)
            } else {
                AppData.ACTIVE_TOPIC = topics[0]
                
            }
            //return authenticatedService.getTopic((AppData.ACTIVE_TOPIC?._id)!)
            return authenticatedService.getTopics(nil)
        
        }.then { topics -> Void in
            AppData.ALL_TOPICS = topics
            self.clearTextFieldsFromInputs()
            self.performSegueWithIdentifier("loginUser", sender: self)
        }

    }

    func clearTextFieldsFromInputs() {
        usernameTextField.text = ""
        passwordTextField.text = ""
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
