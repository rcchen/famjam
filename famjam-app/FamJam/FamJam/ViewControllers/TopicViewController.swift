//
//  TopicViewController.swift
//  FamJam
//
//  Created by Roger Chen on 5/7/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import Foundation
import ReSwift
import UIKit

class TopicViewController: UIViewController, StoreSubscriber {
    var topic: Topic?
    
    @IBOutlet weak var topicNameLabel: UILabel!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showAddPhotoController") {
            let controller = segue.destinationViewController as! NewPhotoViewController
            controller.topicId = (self.topic?._id)!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCurrentTopic()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    @IBAction func unwindToTopicViewController(segue: UIStoryboardSegue) {
    }
    
    func newState(state: AppState) {
        if let topic = state.currentTopic {
            self.topic = topic
            topicNameLabel.text = topic.name
        }
    }

    func fetchCurrentTopic() {
        AuthenticatedApiService.sharedInstance.getTopic("572ea4dd6e607d110025343f")
        .then { topic -> Void in
            print(topic)
            store.dispatch(SetCurrentTopic(currentTopic: topic))
        }
    }
    
}