//
//  TopicViewController.swift
//  FamJam
//
//  Created by Roger Chen on 5/7/16.
//  Copyright © 2016 Famjam. All rights reserved.
//

import CHTCollectionViewWaterfallLayout
import Foundation
import Kingfisher
import ReSwift
import UIColor_Hex_Swift
import UIKit

class TopicViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, StoreSubscriber {
    var topic: Topic?
    var user: User?
    
    @IBOutlet weak var buttonView: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topicNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var submissionCollectionView: UICollectionView!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showAddPhotoController") {
            let controller = segue.destinationViewController as! NewPhotoViewController
            controller.topicId = (self.topic?._id)!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        submissionCollectionView.dataSource = self
        submissionCollectionView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
        fetchCurrentTopic()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    @IBAction func createNewTopic(sender: UIBarButtonItem) {
        var inputTextField = UITextField()
        let alert = UIAlertController(title: "Create new topic", message: "This will change the active topic of the day", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { textField -> Void in
            inputTextField = textField
        }

        alert.addAction(UIAlertAction(title: "Create", style: .Default, handler: { (action: UIAlertAction!) in
            let input = inputTextField.text!
            
            let service = AuthenticatedApiService.sharedInstance
            service.createTopic(input)
                .then { topic -> Void in
                store.dispatch(SetCurrentTopic(currentTopic: topic))
            }

            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func unwindToTopicViewController(segue: UIStoryboardSegue) {
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {


        let family = self.topic!._family!
        let user = family.members![indexPath.row]
        var hasMatch = false
        topic!.images!.forEach { image in
            if (image._creator?._id == user._id!) {
                hasMatch = true
            }
        }

        let cell = submissionCollectionView.dequeueReusableCellWithReuseIdentifier("SubmissionView", forIndexPath: indexPath) as! SubmissionView
        if (hasMatch) {
            Utilities.buildSubmissionViewCell(cell, topic: self.topic!, index: indexPath.row)
        } else {
            Utilities.buildUnsubmittedSubmissionViewCell(cell, username: user.username!)
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topic != nil ? topic!._family!.members!.count : 0
    }

//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let width = collectionView.bounds.width / 2 - 5
//        var height = CGFloat(230)
//        if let topic = self.topic {
//            height = topic.images![indexPath.row].description!.heightWithConstrainedWidth(width, font: UIFont.systemFontOfSize(14)) + width + 35
//        }
//        return CGSizeMake(width, height)
//    }

    func fetchCurrentTopic() {
        AuthenticatedApiService.sharedInstance.getActiveTopic()
            .then { topic -> Void in
                store.dispatch(SetCurrentTopic(currentTopic: topic))
        }
    }
    
    func newState(state: AppState) {
        if let topic = state.currentTopic {
            self.topic = topic
            topicNameLabel.text = topic.name
            submissionCollectionView.reloadData()
            setButtonStatus()
        }
        if let user = state.user {
            self.user = user
        }
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return topic != nil ? 1 : 0
    }

    func setButtonStatus() {
        let submittedUserIds: [String] = self.topic!.images!.map {(image) -> String in
            return image._creator!._id!
        }

        if let user = self.user {
            if submittedUserIds.contains(user._id!) {
                self.buttonView.enabled = false
                self.buttonView.backgroundColor = UIColor(rgba: "#43A047")
                self.buttonView.setTitle("Already submitted!", forState: .Disabled)
            } else {
                self.buttonView.enabled = true
                self.buttonView.backgroundColor = UIColor(rgba: "#03A9F4")
                self.buttonView.setTitle("Add your photo", forState: .Normal)
            }
        }
    }
}