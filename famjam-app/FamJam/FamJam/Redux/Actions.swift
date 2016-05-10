//
//  Actions.swift
//  FamJam
//
//  Created by Roger Chen on 5/7/16.
//  Copyright © 2016 FamJam. All rights reserved.
//

import Foundation
import ReSwift

struct SetUser: Action {
    let user: User
}

struct SetUserFamilies: Action {
    let userFamilies: [Family]
}

struct SetCurrentTopic: Action {
    let currentTopic: Topic
}

