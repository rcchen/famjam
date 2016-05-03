//
//  AuthenticatedApiService.swift
//  FamJam
//
//  Created by Roger Chen on 4/23/16.
//

import Alamofire
import BrightFutures
import Foundation
import JSONHelper

class AuthenticatedApiService: BaseApiService {
    var headers: [String: String] = [:];

    static let sharedInstance = AuthenticatedApiService()

    enum AuthenticatedServiceError : ErrorType {
        case RequestFailed
    }
    
    func setHeaders () {
        let defaults = NSUserDefaults.standardUserDefaults()
        self.headers = [
            "Authorization": defaults.stringForKey(BaseApiService.TOKEN_KEY)!
        ]
    }
    
    func getMe() -> Future<User, AuthenticatedServiceError> {
        let promise = Promise<User, AuthenticatedServiceError>()
        Queue.global.async {
            Alamofire.request(
                .GET,
                "\(BaseApiService.SERVER_BASE_URL)/me",
                encoding: .JSON,
                headers: self.headers
                ).responseJSON { response in
                    if let data = response.result.value {
                        var user: User?
                        user <-- data
                        promise.success(user!)
                    }
            }
        }
        return promise.future
    }
    
    // Creates a new family with the given display name.
    // Will add the authenticated user to the family automatically.
    func createFamily(displayName: String) -> Future<Family, AuthenticatedServiceError> {
        let promise = Promise<Family, AuthenticatedServiceError>()
        Queue.global.async {
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
                    promise.success(family!)
                }
            }
        }
        return promise.future
    }

    func getFamily(id: String) -> Future<Family, AuthenticatedServiceError> {
        let promise = Promise<Family, AuthenticatedServiceError>()
        Queue.global.async {
            Alamofire.request(
                .GET,
                "\(BaseApiService.SERVER_BASE_URL)/families/\(id)",
                encoding: .JSON,
                headers: self.headers
            ).responseJSON { response in
                if let data = response.result.value {
                    var family: Family?
                    family <-- data
                    promise.success(family!)
                }

            }
        }
        return promise.future
    }
    
    // Search for the family with the given display name.
    func getFamilyByDisplayName(displayName: String) -> Future<Family?, AuthenticatedServiceError> {
        let promise = Promise<Family?, AuthenticatedServiceError>()
        Queue.global.async {

            Alamofire.request(
                .GET,
                "\(BaseApiService.SERVER_BASE_URL)/families?displayName=\(displayName)",
                encoding: .JSON,
                headers: self.headers
            ).responseJSON { response in
                print(response)
                if let data = response.result.value {
                    var families: [Family]?
                    families <-- data
                    if (families?.count > 0) {
                        promise.success(families![0])
                    } else {
                        promise.success(nil)
                    }
                }
            }
        }
        return promise.future
    }

    func joinOrCreateFamily(displayName: String) -> Future<Family, AuthenticatedServiceError> {
        let promise = Promise<Family, AuthenticatedServiceError>()
        Queue.global.async {
            self.getFamilyByDisplayName(displayName)
                .onSuccess { family in
                    if let existingFamily = family {
                        self.joinFamily(existingFamily._id!)
                            .onSuccess { _ in
                                self.getFamily(existingFamily._id!)
                                    .onSuccess { updatedFamily in
                                        promise.success(updatedFamily)
                                    }
                            }
                    } else {
                        self.createFamily(displayName)
                            .onSuccess { createdFamily in
                                promise.success(createdFamily)
                        }
                    }
                }
        }
        return promise.future
    }
    
    // Join the family with the given ID
    func joinFamily(id: String) -> Future<Bool, AuthenticatedServiceError> {
        let promise = Promise<Bool, AuthenticatedServiceError>()
        Queue.global.async {
            Alamofire.request(
                .POST,
                "\(BaseApiService.SERVER_BASE_URL)/families/\(id)/join",
                encoding: .JSON,
                headers: self.headers
                ).responseJSON { response in
                    let statusCode = (response.response)!.statusCode
                    promise.success(statusCode == 200)
            }
        }
        return promise.future
    }
    
    // Retrieve topics
    func getTopics(active: Bool?) -> Future<[Topic], AuthenticatedServiceError> {
        let promise = Promise<[Topic], AuthenticatedServiceError>()
        Queue.global.async {
            var url = "\(BaseApiService.SERVER_BASE_URL)/topics"
            if let isActive = active {
                url += "?active=\(isActive)"
            }

            Alamofire.request(
                .GET,
                url,
                encoding: .JSON,
                headers: self.headers
            ).responseJSON { response in
                if let data = response.result.value {
                    var topics: [Topic]?
                    topics <-- data
                    promise.success(topics!)
                }
            }
        }
        return promise.future
    }

    // Retrieve a topic
    func getTopic(topicId: String) -> Future<Topic, AuthenticatedServiceError> {
        let promise = Promise<Topic, AuthenticatedServiceError>()
        Queue.global.async {
            Alamofire.request(
                .GET,
                "\(BaseApiService.SERVER_BASE_URL)/topics/\(topicId)",
                encoding: .JSON,
                headers: self.headers
            ).responseJSON { response in
                if let data = response.result.value {
                    var topic: Topic?
                    topic <-- data
                    promise.success(topic!)
                }
            }
        }
        return promise.future
    }

    
    func getParticipantsForTopic(topicId: String) -> Future<[String: [User]], AuthenticatedServiceError> {
        let promise = Promise<[String: [User]], AuthenticatedServiceError>()
        Queue.global.async {
            Alamofire.request(
                .GET,
                "\(BaseApiService.SERVER_BASE_URL)/topics/\(topicId)/participants",
                encoding: .JSON,
                headers: self.headers
                ).responseJSON { response in
                    if let data = response.result.value {
                        var submitted: [User]?
                        var not_submitted: [User]?
                        
                        submitted <-- data["submitted"]
                        not_submitted <-- data["not_submitted"]
                        
                        promise.success([
                            "submitted": submitted!,
                            "not_submitted": not_submitted!
                        ])
                    }
            }
        }
        return promise.future
    }
    
    func createTopic(name: String) -> Future<Topic, AuthenticatedServiceError> {
        let promise = Promise<Topic, AuthenticatedServiceError>()
        Queue.global.async {
            Alamofire.request(
                .POST,
                "\(BaseApiService.SERVER_BASE_URL)/topics",
                parameters: [
                    "name": name
                ],
                encoding: .JSON,
                headers: self.headers
                ).responseJSON { response in
                    if let data = response.result.value {
                        var topic: Topic?
                        topic <-- data
                        promise.success(topic!)
                    }
            }
        }
        return promise.future
    }

    func updateTopic(topic: Topic) -> Future<Topic, AuthenticatedServiceError> {
        let promise = Promise<Topic, AuthenticatedServiceError>()
        Queue.global.async {
            Alamofire.request(
                .PUT,
                "\(BaseApiService.SERVER_BASE_URL)/topics/\(topic._id!)",
                parameters: [
                    "_id": topic._id!,
                    "active": topic.active!
                ],
                encoding: .JSON,
                headers: self.headers
                ).responseJSON { response in
                    if let data = response.result.value {
                        var topic: Topic?
                        topic <-- data
                        promise.success(topic!)
                    }
            }
        }
        return promise.future
    }
    
    
    func addPhotoToTopic(topicId: String, photo: UIImage, description: String, cb: (Bool) -> Void) {
        let url = "\(BaseApiService.SERVER_BASE_URL)/topics/\(topicId)"
        Alamofire.upload(
            .POST,
            url,
            headers: self.headers,
            multipartFormData: { multipartFormData in
                if let _photoData = UIImageJPEGRepresentation(photo, 0.7) {
                    multipartFormData.appendBodyPart(data: _photoData, name: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
                }
            },
            encodingCompletion: { encodingResult in
                print(encodingResult)
                switch encodingResult {
                case .Success(let upload, _, _):
                    print(upload)
                    upload.responseJSON { response in
                        let statusCode = (response.response)!.statusCode
                        cb(statusCode == 200)
                    }
                case .Failure(let fail):
                    print(fail)
                    cb(false)
                }
            }
        )
    }
}

