//
//  Family.swift
//  FamJam
//
//  Created by Roger Chen on 5/3/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import ObjectMapper

class Topic: Mappable {
    var _creator: User?
    var _family: Family?
    var _id: String?
    var active: Bool?
    var images: [Image]?
    var locked: Bool?
    var name: String?
    
    required init?(_ map: Map) {
        // no-op
    }
    
    func mapping(map: Map) {
        _creator <- map["_creator"]
        _family <- map["_family"]
        _id <- map["_id"]
        active <- map["active"]
        images <- map["images"]
        locked <- map["locked"]
        name <- map["name"]
    }
}

class ParticipantResponse: Mappable {
    var submitted: [User]?
    var not_submitted: [User]?

    required init?(_ map: Map) {
        // no-op
    }

    func mapping(map: Map) {
        submitted <- map["submitted"]
        not_submitted <- map["not_submitted"]
    }
}