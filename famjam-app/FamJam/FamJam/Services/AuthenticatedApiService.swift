//
//  AuthenticatedApiService.swift
//  FamJam
//
//  Created by Roger Chen on 4/23/16.
//

import Alamofire
import Foundation
import JSONHelper

class AuthenticatedApiService: BaseApiService {
    let headers: [String: String];

    override init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        self.headers = [
            "Authorization": defaults.stringForKey(BaseApiService.TOKEN_KEY)!
        ]
    }

    func getFeed(cb: ([Topic]) -> Void) {
        Alamofire.request(
            .GET,
            "\(BaseApiService.SERVER_BASE_URL)/topics",
            encoding: .JSON,
            headers: self.headers
        ).responseJSON { response in
            if let data = response.result.value {
                var topics: [Topic]?
                topics <-- data["topics"]
                cb(topics!)
            }
        }
    }

    func getTopic(topicId: String, cb: (User, Topic) -> Void) {
        Alamofire.request(
            .GET,
            "\(BaseApiService.SERVER_BASE_URL)/topics/\(topicId)",
            encoding: .JSON,
            headers: self.headers
        ).responseJSON { response in
            if let data = response.result.value {
                var topic: Topic?
                var user: User?

                user <-- data["user"]
                topic <-- data["topic"]
                
                cb(user!, topic!)
            }
        }
    }
}

