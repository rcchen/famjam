//
//  ProfileViewController.swift
//  FamJam
//
//  Created by Roger Chen on 5/9/16.
//  Copyright © 2016 Famjam. All rights reserved.
//

import Foundation
import ReSwift
import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StoreSubscriber {
    var user: User?
    var userFamilies: [Family]?

    @IBOutlet weak var familiesView: UITableView!
    @IBOutlet weak var nameView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the table view
        familiesView.dataSource = self
        familiesView.delegate = self

        // retrieve family data
        fetchFamilies()
        fetchUserInfo()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    @IBAction func didPressLogout(sender: UIBarButtonItem) {
        AnonymousApiService.logoutUser()
            .then { _ -> Void in
            self.performSegueWithIdentifier("logoutSegue", sender: nil)
        }
    }

    func fetchFamilies() {
        let service = AuthenticatedApiService.sharedInstance
        service.getMeFamilies()
            .then { families -> Void in
                store.dispatch(SetUserFamilies(userFamilies: families))
        }
    }

    func fetchUserInfo() {
        AuthenticatedApiService.sharedInstance.getMe()
            .then { user -> Void in
                store.dispatch(SetUser(user: user))
        }
    }
    
    func newState(state: AppState) {
        if let user = state.user {
            self.user = user
            setUserInfo()
        }
        if let families = state.userFamilies {
            self.userFamilies = families
            self.familiesView.reloadData()
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return userFamilies != nil ? userFamilies!.count : 0
    }

    func setUserInfo() {
        let attributes = self.user!.attributes!
        nameView.text = attributes.keys.contains("displayName") ? attributes["displayName"] : self.user!.username!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFamilies != nil ? userFamilies![section].members!.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserView", forIndexPath: indexPath) as! UserView

        if let families = userFamilies {
            let family = families[indexPath.section]
            let member = family.members![indexPath.row]
            cell.displayNameLabel.text = member.attributes!["displayName"]
            cell.usernameLabel.text = member.username!
        }
        
        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let families = userFamilies {
            let familyAttributes = families[section].attributes!
            return familyAttributes.keys.contains("displayName") ? familyAttributes["displayName"] : ""
        }
        return "Section \(section)"
    }
}
