//
//  State.swift
//  FamJam
//
//  Created by Roger Chen on 5/7/16.
//  Copyright © 2016 FamJam. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    var currentTopic: Topic?
    var topics: [Topic]?
    var user: User?
    var userFamilies: [Family]?
}