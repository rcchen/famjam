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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displaynameTextField: UITextField!
    @IBOutlet weak var familyTextField: UITextField!
    
    @IBAction func doneButtonPressed(sender: UIButton) {
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
                
                return authenticatedService.getTopics(true)
                
            }.then { topics -> Promise<[Topic]> in
                if (topics.count == 0) {
                    AppData.ACTIVE_TOPIC = nil
                } else {
                    AppData.ACTIVE_TOPIC = topics[0]
                }
                
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
