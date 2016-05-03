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
    var _family: Family?
    var active: Bool?
    var images: [Image]?
    var locked: Bool?
    var name: String?

    init(data: [String: AnyObject]) {
        _id <-- data["_id"]
        _creator <-- data["_creator"]
        _family <-- data["_family"]
        active <-- data["active"]
        images <-- data["images"]
        locked <-- data["locked"]
        name <-- data["name"]
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

struct Family: Deserializable {
    var _id: String?
    var attributes: [String: String]?
    var members: [User]?

    init(data: [String: AnyObject]) {
        _id <-- data["_id"]
        attributes <-- data["attributes"]
        members <-- data["members"]
    }
}

struct User: Deserializable {
    var _id: String?
    var attributes: [String: String]?
    var families: [String]?
    var username: String?

    init(data: [String: AnyObject]) {
        _id <-- data["_id"]
        attributes <-- data["attributes"]
        families <-- data["families"]
        username <-- data["username"]
    }
}