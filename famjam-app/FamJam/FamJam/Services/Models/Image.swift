//
//  Photo.swift
//  FamJam
//
//  Created by Roger Chen on 5/3/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import ObjectMapper

class Image: Mappable {
    var _id: String?
    var _creator: User?
    var _topic: String?
    var description: String?
    var url: String?
    
    required init?(_ map: Map) {
        // no-op
    }
    
    func mapping(map: Map) {
        _creator <- map["_creator"]
        _id <- map["_id"]
        _topic <- map["_topic"]
        description <- map["description"]
        url <- map["url"]
    }
}