//
//  AllPhotosViewController.swift
//  FamJam
//
//  Created by Lucio Tan on 4/24/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import UIKit

class AllPhotosViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var allPhotosCollectionView: UICollectionView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        allPhotosCollectionView.dataSource = self
        allPhotosCollectionView.registerClass(AlbumHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        allPhotosCollectionView.backgroundColor = Constants.FAMJAM_ORANGE_COLOR
        navigationBar.barTintColor = Constants.FAMJAM_ORANGE_COLOR
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        allPhotosCollectionView.reloadData()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //return AllPhotosConstants.THEMES.count
        print("All Topics in AllPhotosVC: ")
        print(AppData.ALL_TOPICS)
        print("Total Sections: ")
        print(AppData.ALL_TOPICS.count)
        return (AppData.ALL_TOPICS.count)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return UserData.NAMES.count
        //return AppDataFunctions.getNumFamilyMembersFromFamily(AppData.ACTIVE_FAMILY!)
        
        print("Section #: ")
        print(section)
        
        print("Topic in ALLPHOTOSVC: ")
        print(AppData.ALL_TOPICS[section].name)
    
        
        print("All images for topic in AllPhotosVC: ")
        print(AppData.ALL_TOPICS[section].images)
        if let imagesForSection = AppData.ALL_TOPICS[section].images {
            return imagesForSection.count
        } else {
            return 0
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("allPhotosCell", forIndexPath: indexPath) as! AllPhotosCollectionViewCell
        
        //cell.name.text = UserData.NAMES[indexPath.row]
        
//        let cellImage = AppDataFunctions.getUserPhotoForAllPhotosVCForIndexPath(indexPath)
        
//        cell.name.text = AppData.ALL_TOPICS[indexPath.section].images![indexPath.row]._creator
//        print("CELLIMAGE")
//        print(cellImage)
//        if (cellImage._creator?.attributes != nil) {
//            cell.name.text = cellImage._creator?.attributes!["displayName"]
//        } else {
//            cell.name.text = cellImage._creator?.username
//        }
//        
//        
//        //cell.photo.image = UIImage(named: Constants.DEFAULT_LOCK_IMAGE_NAME)
////        let imageURL = NSURL(string: AppData.ALL_TOPICS[indexPath.section].images![indexPath.row].url!)
//        let imageURL = NSURL(string: cellImage.url!)
//        
//        let imageData = NSData(contentsOfURL: imageURL!)
//        
//        cell.photo.image = UIImage(data: imageData!)
//        
//        cell.caption.text = AppData.ALL_TOPICS[indexPath.section].images![indexPath.row].description
//        
//        cell.name.font = Constants.FAMJAM_SUBHEADER_FONT
//        cell.caption.font = Constants.FAMJAM_FONT
//        cell.name.textColor = Constants.FAMJAM_WHITE_COLOR
//        cell.caption.textColor = Constants.FAMJAM_WHITE_COLOR
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as? AlbumHeaderCollectionReusableView
            //headerView!.changeLabelTitle(AllPhotosConstants.THEMES[indexPath.section])
//            print("SECTION # IN COLLECTION VIEW: ")
//            print(indexPath.section)
//            print(indexPath.row)
//            print(AppData.ALL_TOPICS[indexPath.section].images!)
//            print((AppData.ALL_TOPICS[indexPath.section].images![indexPath.row]._creator)!)
            headerView!.changeLabelTitle((AppData.ALL_TOPICS[indexPath.section].name)!)
            return headerView!
        default:
            assert(false, "Unexpected element kind")
            fatalError("Unexpected element kind")

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
