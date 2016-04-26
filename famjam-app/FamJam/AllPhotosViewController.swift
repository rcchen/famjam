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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return AllPhotosConstants.THEMES.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserData.NAMES.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("allPhotosCell", forIndexPath: indexPath) as! AllPhotosCollectionViewCell
        
        cell.name.text = UserData.NAMES[indexPath.row]
        cell.photo.image = UIImage(named: Constants.DEFAULT_LOCK_IMAGE_NAME)
        cell.caption.text = Constants.DEFAULT_LOCK_TEXT
        
        cell.name.font = Constants.FAMJAM_SUBHEADER_FONT
        cell.caption.font = Constants.FAMJAM_FONT
        cell.name.textColor = Constants.FAMJAM_WHITE_COLOR
        cell.caption.textColor = Constants.FAMJAM_WHITE_COLOR
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as? AlbumHeaderCollectionReusableView
            headerView!.changeLabelTitle(AllPhotosConstants.THEMES[indexPath.section])
            return headerView!
            
            
        default:
            assert(false, "Unexpected element kind")
            
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
