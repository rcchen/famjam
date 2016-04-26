//
//  FamilyDashboardViewController.swift
//  FamJam
//
//  Created by Lucio Tan on 4/25/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import UIKit

class FamilyDashboardViewController: UIViewController, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.familyDashboardTableView.dataSource = self
        welcomeLabel.text = welcomeLabel.text?.stringByAppendingString(AppData.ACTIVE_USER)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return FamilyDashboardConstants.NUM_SECTIONS
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FamilyDashboardConstants.NUM_ROWS_IN_SECTION
    }
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("familyCell", forIndexPath: indexPath) as! FamilyTableViewCell
        let nameString = UserData.NAMES[indexPath.row]
        cell.name.text = nameString
        if (nameString == AppData.ACTIVE_USER) {
            cell.remindButton.hidden = true
        }
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
