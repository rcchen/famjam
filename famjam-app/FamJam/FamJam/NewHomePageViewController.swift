//
//  NewHomePageViewController.swift
//  FamJam
//
//  Created by Lucio Tan on 4/23/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData
import Social
import AssetsLibrary


// This is the viewcontroller for the "Theme of the Day" page
class NewHomePageViewController: UIViewController, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showPhoto" {
            let destination = segue.destinationViewController as? PhotoDetailViewController
            let cell = sender as! PhotoCollectionViewCell
            destination!.imageView.image = cell.photo.image!
        } else if segue.identifier == "savePhoto" {
            let destination = segue.destinationViewController as? SavingPhotoViewController
            //destination!.savedImageURL = imageURL
            destination!.imageData = imageData
            destination!.savedImageReference = savedImage
            //destination!.savedImage.image = savedImage
        }
        
    }
    
    @IBAction func unwindFromSavingPhotosToThemeOfDay(segue: UIStoryboardSegue) {
        
//        if segue.identifier == "savedPhoto" {
//            let source = segue.sourceViewController as? SavingPhotoViewController
//            defaultCaption = (source?.captionTextField.text)!
//            savedImage = source?.savedImageReference
//            pageIsLocked = false
//            photoCollectionView.reloadData()
//        }
        
        photoCollectionView.reloadData()
    }
    
    @IBAction func unwindFromPhotoDetailView(segue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindFromNewTopicViewCancel(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromNewTopicViewSave(segue: UIStoryboardSegue) {
        print("Unwinded from new topic view")
        collectionView.reloadData()
    }
    
    
    // Variables for this controller
    //var defaultCaption = ""
    var savedImage:UIImage?
    var pageIsLocked = true
    
    //var imageURL:NSURL?
    
    var imageData:NSData?
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        photoCollectionView.dataSource = self
        collectionView.registerClass(AlbumHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = Constants.FAMJAM_ORANGE_COLOR
        navigationBar.barTintColor = Constants.FAMJAM_ORANGE_COLOR
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return ThemeOfDayConstants.NUM_SECTIONS
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ThemeOfDayConstants.NUM_ROWS_IN_SECTION
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        
        // TODO: Need to actually render family members here
//        if (AppDataFunctions.getActiveUsername(AppData.ACTIVE_USER!) == UserData.NAMES[indexPath.row]) {
//            cell.photo.image = savedImage
//            //cell.caption.text = defaultCaption
//        } else if (pageIsLocked) {
//            cell.photo.image = UIImage(named: Constants.DEFAULT_LOCK_IMAGE_NAME)
//            cell.caption.text = Constants.DEFAULT_LOCK_TEXT
//        } else {
//            cell.caption.text = UserData.USER_PHOTO_CAPTIONS[indexPath.row]
//            cell.photo.image = UIImage(named: UserData.USER_PHOTO_NAMES[indexPath.row])
//        }
        
        let currentUser = AppDataFunctions.getFamilyMemberFromIndexPath(indexPath)
        let userName = currentUser.attributes!["displayName"]
        
        
        
//        cell.name.text = UserData.NAMES[indexPath.row]
        cell.name.text = userName
        
        
        
        // Formatting cell properties
        cell.caption.font = Constants.FAMJAM_FONT
        cell.name.font = Constants.FAMJAM_SUBHEADER_FONT
        cell.name.textColor = Constants.FAMJAM_WHITE_COLOR
        cell.caption.textColor = Constants.FAMJAM_WHITE_COLOR
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as? AlbumHeaderCollectionReusableView
            print("ACTIVE TOPIC WHEN PRINTING: ")
            print(AppData.ACTIVE_TOPIC)
            headerView!.changeLabelTitle(AppData.ACTIVE_TOPIC!.name!)
            return headerView!

        
        default:
            assert(false, "Unexpected element kind")
            
        }
    }
    
    

    @IBAction func newPicture(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.mediaTypes = [kUTTypeImage as String]
            picker.delegate = self
            picker.allowsEditing = true
            
            // Presenting picker
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    // Take picture case
    // The imagePictureController will perform its task and return the result to this class
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }

        imageData = UIImageJPEGRepresentation(image!, 0.7)
        
        savedImage = image!
        
        //let library = ALAssetsLibrary()
        
//        library.writeImageToSavedPhotosAlbum(image?.CGImage, metadata: info[UIImagePickerControllerMediaMetadata] as! [String : AnyObject], completionBlock: {(path: NSURL, error: NSError) -> Void in
//            
//            
//        })
        
        /*
        library.writeImageToSavedPhotosAlbum(image?.CGImage, orientation: ALAssetOrientation(rawValue: image!.imageOrientation.rawValue)!, completionBlock: { (path:NSURL!, error:NSError!) -> Void in
            self.imageURL = path
            print("imageURL: ")
            print(self.imageURL)
            
        })
 */
        
        //UIImageWriteToSavedPhotosAlbum(image!, self, #selector(NewHomePageViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        
        
        
        dismissViewControllerAnimated(true, completion: {
            self.performSegueWithIdentifier("savePhoto", sender: self)
        })
 
        
//        print("Image URL: ")
//        print(imageURL)
        
        
    }
    // Cancel case
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
//    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
//        guard error == nil else {
//            return
//        }
//        //imageURL = error?.userInfo[imageURL!] as? NSURL
//        imageURL = error?.userInfo[UIImagePickerControllerReferenceURL] as? NSURL
//        print("Image URL: ")
//        print(imageURL)
//        
//        error?.userInfo
//        
////        dismissViewControllerAnimated(true, completion: {
////            self.performSegueWithIdentifier("savePhoto", sender: self)
////        })
//        
//        //self.performSegueWithIdentifier("savePhoto", sender: self)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
