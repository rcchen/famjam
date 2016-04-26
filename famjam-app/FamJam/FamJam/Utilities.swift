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
}

class UserData {
    static let NAMES = ["Lucio", "Stephen", "Roger", "Emma"]
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
    static var ACTIVE_USER = "Lucio"
    static var ACTIVE_THEME = "Random"
}

class TabItemLabels {
    static var FIRST_LABEL = "My Family"
    static var SECOND_LABEL = "Theme of the Day"
    static var THIRD_LABEL = "All our Photos"
}

class AllPhotosConstants {
    static let THEMES = ["Random", "Lunch", "Winning", "Cute Animals", "Dessert"]
}