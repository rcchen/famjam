//
//  AllTopicsViewController.swift
//  FamJam
//
//  Created by Roger Chen on 5/11/16.
//  Copyright © 2016 Famjam. All rights reserved.
//

import CHTCollectionViewWaterfallLayout
import Foundation
import ReSwift
import UIKit

class AllTopicsViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, StoreSubscriber {
    var topics: [Topic]?

    @IBOutlet weak var topicsCollectionView: UICollectionView!
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//        
//        topicsCollectionView.dataSource = self
////        topicsCollectionView.registerClass(AlbumHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        topicsCollectionView.dataSource = self
        topicsCollectionView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
        fetchTopics()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return topics != nil ? topics!.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics != nil ? topics![section].images!.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = topicsCollectionView.dequeueReusableCellWithReuseIdentifier("SubmissionView", forIndexPath: indexPath) as! SubmissionView
        if let topics = self.topics {
            Utilities.buildSubmissionViewCell(cell, topic: topics[indexPath.section], index: indexPath.row)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "TopicsCollectionHeader", forIndexPath: indexPath) as? TopicHeaderView
            if let topics = self.topics {
                let topic = topics[indexPath.section]
                headerView?.title.text = topic.name!
            }
            return headerView!
        default:
            assert(false, "Unexpected element kind")
            fatalError("Unexpected element kind")
        }
        
    }

    func fetchTopics() {
        AuthenticatedApiService.sharedInstance.getTopics(nil)
            .then { topics -> Void in
                store.dispatch(SetTopics(topics: topics))
        }
    }
    
    func newState(state: AppState) {
        if let topics = state.topics {
            self.topics = topics
            topicsCollectionView.reloadData()
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