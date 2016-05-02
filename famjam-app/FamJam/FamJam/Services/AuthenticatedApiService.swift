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
        print("Setting headers")
    }

    func getMe(cb: (User) -> Void) {
        Alamofire.request(
            .GET,
            "\(BaseApiService.SERVER_BASE_URL)/me",
            encoding: .JSON,
            headers: self.headers
        ).responseJSON { response in
            if let data = response.result.value {
                var user: User?
                user <-- data
                cb(user!)
            }
        }
    }
    
    // Creates a new family with the given display name.
    // Will add the authenticated user to the family automatically.
    func createFamily(displayName: String, cb: (Family) -> Void) {
        Alamofire.request(
            .POST,
            "\(BaseApiService.SERVER_BASE_URL)/families",
            parameters: [
                "displayName": displayName
            ],
            encoding: .JSON,
            headers: self.headers
        ).responseJSON { response in
            if let data = response.result.value {
                var family: Family?
                family <-- data
                cb(family!)
            }
        }
    }

    // Search for the family with the given display name.
    func getFamilyByDisplayName(displayName: String, cb: (Family?) -> Void) {
        Alamofire.request(
            .GET,
            "\(BaseApiService.SERVER_BASE_URL)/families?displayName=\(displayName)",
            encoding: .JSON,
            headers: self.headers
        ).responseJSON { response in
            if let data = response.result.value {
                var families: [Family]?
                families <-- data
                if (families?.count > 0) {
                    cb(families![0])
                } else {
                    cb(nil)
                }
            }
        }
    }

    // Join the family with the given ID
    func joinFamily(id: String, cb: (Bool) -> Void) {
        Alamofire.request(
            .POST,
            "\(BaseApiService.SERVER_BASE_URL)/families/\(id)/join",
            encoding: .JSON,
            headers: self.headers
        ).responseJSON { response in
            let statusCode = (response.response)!.statusCode
            cb(statusCode == 200)
        }
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
                topics <-- data
                cb(topics!)
            }
        }
    }

    // Retrieve a topic
    func getTopic(topicId: String, cb: (Topic) -> Void) {
        Alamofire.request(
            .GET,
            "\(BaseApiService.SERVER_BASE_URL)/topics/\(topicId)",
            encoding: .JSON,
            headers: self.headers
        ).responseJSON { response in
            if let data = response.result.value {
                var topic: Topic?
                topic <-- data
                cb(topic!)
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

