//
//  FamilyDashboardViewController.swift
//  FamJam
//
//  Created by Lucio Tan on 4/25/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import UIKit

class FamilyDashboardViewController: UIViewController, UITableViewDataSource {
    
    
    @IBAction func unwindFromEditUserCancel(segue: UIStoryboardSegue) {
    
    }
    
    @IBAction func unwindFromEditUserSave(segue: UIStoryboardSegue) {
    
    }
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var topViewNameLabel: UILabel!
    
    @IBOutlet weak var familyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.familyDashboardTableView.dataSource = self
        welcomeLabel.text = welcomeLabel.text?.stringByAppendingString(AppDataFunctions.getActiveUserDisplayname(AppData.ACTIVE_USER!))
        profilePicture.image = UIImage(named: "lucioImage")
        topViewNameLabel.text = AppDataFunctions.getActiveUserDisplayname(AppData.ACTIVE_USER!)
        familyLabel.text = "Family: " + AppDataFunctions.getActiveFamilyname(AppData.ACTIVE_FAMILY!)
        
        welcomeLabel.font = Constants.FAMJAM_SUBHEADER_FONT
        welcomeLabel.textColor = Constants.FAMJAM_WHITE_COLOR
        
        topViewNameLabel.font = Constants.FAMJAM_HEADER_FONT
        topViewNameLabel.textColor = Constants.FAMJAM_WHITE_COLOR
        
        familyLabel.font = Constants.FAMJAM_SUBHEADER_FONT
        familyLabel.textColor = Constants.FAMJAM_WHITE_COLOR
        
        navigationBar.barTintColor = Constants.FAMJAM_ORANGE_COLOR
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return FamilyDashboardConstants.NUM_SECTIONS
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return FamilyDashboardConstants.NUM_ROWS_IN_SECTION
        print(AppData.ACTIVE_FAMILY)
        return AppDataFunctions.getNumFamilyMembersFromFamily(AppData.ACTIVE_FAMILY!)
        
        
    }
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("familyCell", forIndexPath: indexPath) as! FamilyTableViewCell
        let nameString = UserData.NAMES[indexPath.row]
        cell.name.text = nameString
        cell.name.font = Constants.FAMJAM_SUBHEADER_FONT
        if (nameString == AppDataFunctions.getActiveUserDisplayname(AppData.ACTIVE_USER!)) {
            cell.remindButton.hidden = true
        }
        cell.profilePicture.image = UIImage(named: UserData.USER_PHOTO_NAMES[indexPath.row])
        cell.name.textColor = Constants.FAMJAM_WHITE_COLOR
        return cell
    }
    
    
    
    @IBOutlet weak var familyDashboardTableView: UITableView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
