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
    var headers: [String: String] = [:];

    static let sharedInstance = AuthenticatedApiService()
    
    func setHeaders () {
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

    
    func addPhotoToTopic(topicId: String, photoUrl: NSURL, description: String, cb: (Bool) -> Void) {
        let url = "\(BaseApiService.SERVER_BASE_URL)/topics/\(topicId)"
        Alamofire.upload(
            .POST,
            url,
            headers: self.headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: photoUrl, name: "photo")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        let statusCode = (response.response)!.statusCode
                        cb(statusCode == 200)
                    }
                case .Failure(_):
                    cb(false)
                }
            }
        )
    }
}

