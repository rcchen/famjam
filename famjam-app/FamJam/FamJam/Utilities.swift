//
//  Utilities.swift
//  FamJam
//
//  Created by Lucio Tan on 4/24/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    static let ALBUM_HEADER_LABEL_WIDTH = 300.0 as CGFloat
    static let ALBUM_HEADER_LABEL_HEIGHT = 75.0 as CGFloat
    static let ALBUM_HEADER_OFFSET_Y = 5 as CGFloat
    static let DEFAULT_LOCK_TEXT = "This album is locked. Upload your own photo to see it!"
    static let DEFAULT_LOCK_IMAGE_NAME = "lockImage"
    static let FAMJAM_FONT = UIFont(name: "Apple SD Gothic Neo", size: 16)
    static let FAMJAM_SUBHEADER_FONT = UIFont(name: "Apple SD Gothic Neo", size: 20)
    static let FAMJAM_HEADER_FONT = UIFont(name: "Apple SD Gothic Neo", size: 24)
    static let FAMJAM_WHITE_COLOR = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let FAMJAM_DARK_BLUE_COLOR = UIColor(red: 0/255, green: 45/255, blue: 64/255, alpha: 1.0)
    static let FAMJAM_BLUE_COLOR = UIColor(red: 42/255, green: 87/255, blue: 106/255, alpha: 1.0)
    static let FAMJAM_LIGHT_ORANGE_COLOR = UIColor(red: 251/255, green: 188/255, blue: 75/255, alpha: 1.0)
    static let FAMJAM_ORANGE_COLOR = UIColor(red: 250/255, green: 150/255, blue: 0/255, alpha: 1.0)
}

class UserData {
    //static let NAMES = ["Lucio", "Stephen", "Roger", "Emma"]
    static let USER_PHOTO_NAMES = ["lucioImage", "stephenImage", "rogerImage", "emmaImage"]
    static let USER_PHOTO_CAPTIONS = ["Excited to be doing this project!", "Om nom nom", "Looking good!", "Should I use this as my LinkedIn profile pic?"]
}

class FamilyDashboardConstants {
    static let NUM_SECTIONS = 1
    static let NUM_ROWS_IN_SECTION = 4
}

class ThemeOfDayConstants {
    static let NUM_SECTIONS = 1
    static let NUM_ROWS_IN_SECTION = 4
}

class AppData {
    static var ACTIVE_TOPIC: Topic?
    static var ACTIVE_USER: User?
    static var ACTIVE_FAMILY: Family?
    //static var ACTIVE_FAMILY_MEMBERS: [User]?
    static var ALL_TOPICS = [Topic]()
}

class TabItemLabels {
    static var FIRST_LABEL = "My Family"
    static var SECOND_LABEL = "Theme of the Day"
    static var THIRD_LABEL = "All Our Photos"
}

class AllPhotosConstants {
    //static let THEMES = ["Random", "Lunch", "Winning", "Cute Animals", "Dessert", "Night-Out"]
}

class AppDataFunctions {
    
    static func getActiveUsername(user: User) -> String {
        return user.username!
    }
    
    static func getActiveUserDisplayname(user: User) -> String {
        return user.attributes!["displayName"]!
    }
    
    static func getActiveFamilyname(family: Family) -> String {
        return family.attributes!["displayName"]!
    }
    
//    static func getFamilyMembersFromFamily(family: Family) -> [User] {
//        return family.members!
//    }
    
//    static func getNumFamilyMembersFromFamily(family: Family) -> Int {
//        return family.members!.count
//    }
    
//    static func getFamilyMemberNameFromIndexPath(indexPath: NSIndexPath) -> String {
//        return (AppData.ACTIVE_FAMILY?.members![indexPath.row].attributes!["displayName"]!)!
//    }
    
//    static func getFamilyMemberFromIndexPath(indexPath: NSIndexPath) -> User {
//        return (AppData.ACTIVE_FAMILY?.members![indexPath.row])!
//    }
    
    
//    static func hasUserSubmittedPhotoForTopic(user: User, topic: Topic) -> Bool {
//        let usersWhoSubmittedPhotoToTopic =
//    }
    
    
//    static func hasUserSubmittedPhotoForTopic(user: User, topic: Topic) -> Bool {
//        AuthenticatedApiService.sharedInstance.getParticipantsForTopic(topic._id!)
//            .onSuccess(callback: { infoMap in
//                let submittedUsersArray = infoMap["submitted"]
//                for currUser in submittedUsersArray! {
//                    if (user._id == currUser._id) {
//                        return true
//                    }
//                }
//                return false
//            })
//    }
    
    static func getUserPhotoFromPhotosInTopic(topic: Topic, user: User) -> Image? {
        let userPhotos = topic.images
        for userPhoto in userPhotos! {
            if(userPhoto._creator == user._id) {
                return userPhoto
            }
        }
        return nil
    }
    
    static func addTopicsToAllTopicsArray(topics: [Topic]) {
        for topic in topics {
//            print("NOW ADDING TOPIC TO ALL TOPICS ARRAY: ")
//            print(topic)
            AppData.ALL_TOPICS.append(topic)
//            print("TOTAL ELEMENTS IN ALL TOPICS ARRAY: ")
//            print(AppData.ALL_TOPICS.count)
        }
    }
    
}


