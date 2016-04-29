//
//  Topic.swift
//  FamJam
//
//  Created by Roger Chen on 4/28/16.
//

import JSONHelper
import Foundation

struct Topic: Deserializable {
    var _id: String?
    var _creator: User?
    var name: String?
    var images: [Image]?

    init(data: [String: AnyObject]) {
        _id <-- data["_id"]
        _creator <-- data["_creator"]
        name <-- data["name"]
        images <-- data["images"]
    }
}

struct Image: Deserializable {
    var _id: String?
    var _creator: String?
    var _topic: String?
    var description: String?
    var url: String?

    init(data: [String: AnyObject]) {
        _id <-- data["_id"]
        _creator <-- data["_creator"]
        _topic <-- data["_topic"]
        description <-- data["description"]
        url <-- data["url"]
    }
}

struct User: Deserializable {
    var _id: String?
    var username: String?

    init(data: [String: AnyObject]) {
        _id <-- data["_id"]
        username <-- data["username"]
    }
}