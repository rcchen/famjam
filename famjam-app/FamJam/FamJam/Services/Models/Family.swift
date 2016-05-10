//
//  Topic.swift
//  FamJam
//
//  Created by Roger Chen on 5/3/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import ObjectMapper

class Family: Mappable {
    var _id: String?
    var attributes: [String: String]?
    var members: [User]?
    
    required init?(_ map: Map) {
        // no-op
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        attributes <- map["attributes"]
        members <- map["members"]
    }
}