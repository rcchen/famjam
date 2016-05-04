//
//  User.swift
//  FamJam
//
//  Created by Roger Chen on 5/3/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    var _id: String?
    var attributes: [String: String]?
    var families: [String]?
    var username: String?
    
    required init?(_ map: Map) {
        // no-op
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        attributes <- map["attributes"]
        families <- map["families"]
        username <- map["username"]
    }
}