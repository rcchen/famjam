//
//  Actions.swift
//  FamJam
//
//  Created by Roger Chen on 5/7/16.
//  Copyright © 2016 FamJam. All rights reserved.
//

import Foundation
import ReSwift

struct SetCurrentTopic: Action {
    let currentTopic: Topic
}

struct SetTopics: Action {
    let topics: [Topic]
}

struct SetUser: Action {
    let user: User
}

struct SetUserFamilies: Action {
    let userFamilies: [Family]
}
