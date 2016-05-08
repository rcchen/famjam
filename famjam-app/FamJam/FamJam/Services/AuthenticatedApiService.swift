//
//  AuthenticatedApiService.swift
//  FamJam
//
//  Created by Roger Chen on 4/23/16.
//

import Alamofire
import AlamofireObjectMapper
import Foundation
import PromiseKit

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
    
    /**
         ### Description
         
         Retrieves the current user.
         
         ### Endpoint
         
         /api/me
     */
    func getMe() -> Promise<User> {
        return Promise { fulfill, reject in
            Alamofire.request(
                .GET,
                "\(BaseApiService.SERVER_BASE_URL)/me",
                encoding: .JSON,
                headers: self.headers
            ).responseObject { (response: Response<User, NSError>) in
                let user = response.result.value
                fulfill(user!)
            }
        }
    }

    /**
        ### Description
     
        Retrieves the current user's families.
     
        ### Endpoint
        
        /api/me/families
    */
    func getMeFamilies() -> Promise<[Family]> {
        return Promise { fulfill, reject in
            Alamofire.request(
                .GET,
                "\(BaseApiService.SERVER_BASE_URL)/me/families",
                encoding: .JSON,
                headers: self.headers
            ).responseArray { (response: Response<[Family], NSError>) in
                let families = response.result.value
                fulfill(families!)
            }
        }
    }
    
    // Creates a new family with the given display name.
    // Will add the authenticated user to the family automatically.
    func createFamily(displayName: String) -> Promise<Family> {
        return Promise { fulfill, reject in
            Alamofire.request(
                .POST,
                "\(BaseApiService.SERVER_BASE_URL)/families",
                parameters: [
                    "displayName": displayName
                ],
                encoding: .JSON,
                headers: self.headers
            ).responseObject { (response: Response<Family, NSError>) in
                let family = response.result.value
                fulfill(family!)
            }
        }
    }

    /**
         ### Description
         
         Retrieves a family by ID.
         
         ### Endpoint
         
         /api/families/:id
     */
    func getFamily(id: String) -> Promise<Family> {
        return Promise { fulfill, reject in
            Alamofire.request(
                .GET,
                "\(BaseApiService.SERVER_BASE_URL)/families/\(id)",
                encoding: .JSON,
                headers: self.headers
            ).responseObject { (response: Response<Family, NSError>) in
                let family = response.result.value
                fulfill(family!)
            }
        }
    }

    /**
         ### Description
         
         Retrieves members of a family.
         
         ### Endpoint
         
         /api/families/:id/members
     */
    func getFamilyMembers(id: String) -> Promise<[User]> {
        return Promise { fulfill, reject in
            Alamofire.request(
                .GET,
                "\(BaseApiService.SERVER_BASE_URL)/families/\(id)/members",
                encoding: .JSON,
                headers: self.headers
            ).responseArray { (response: Response<[User], NSError>) in
                let users = response.result.value
                fulfill(users!)
            }
        }
    }
    
    // Search for the family with the given display name.
    func getFamilyByDisplayName(displayName: String) -> Promise<Family?> {
        return Promise { fulfill, reject in
            Alamofire.request(
                .GET,
                "\(BaseApiService.SERVER_BASE_URL)/families?displayName=\(displayName)",
                encoding: .JSON,
                headers: self.headers
            ).responseArray { (response: Response<[Family], NSError>) in
                if let families = response.result.value {
                    if (families.count > 0) {
                        fulfill(families[0])
                    } else {
                        fulfill(nil)
                    }
                }
            }
        }
    }

    func joinOrCreateFamily(displayName: String) -> Promise<Family> {
        return Promise { fulfill, reject in
            self.getFamilyByDisplayName(displayName)
            .then { family -> Promise<Family> in
                if let existingFamily = family {
                    return self.joinFamily(existingFamily._id!)
                    .then { Bool -> Promise<Family> in
                        return self.getFamily(existingFamily._id!)
                    }
                } else {
                    return self.createFamily(displayName)
                }
            }.then { family -> Void in
                fulfill(family)
            }
        }
    }
    
    // Join the family with the given ID
    func joinFamily(id: String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            Alamofire.request(
                .POST,
                "\(BaseApiService.SERVER_BASE_URL)/families/\(id)/join",
                encoding: .JSON,
                headers: self.headers
                ).responseJSON { response in
                    let statusCode = (response.response)!.statusCode
                    fulfill(statusCode == 200)
            }
        }
    }
    
    // Retrieve topics
    func getTopics(active: Bool?) -> Promise<[Topic]> {
        return Promise { fulfill, reject in
            var url = "\(BaseApiService.SERVER_BASE_URL)/topics"
            if let isActive = active {
                url += "?active=\(isActive)"
            }

            Alamofire.request(
                .GET,
                url,
                encoding: .JSON,
                headers: self.headers
            ).responseArray { (response: Response<[Topic], NSError>) in
                let topics = response.result.value
                fulfill(topics!)
            }
        }
    }

    // Retrieve a topic
    func getTopic(topicId: String) -> Promise<Topic> {
        return Promise { fulfill, reject in
            Alamofire.request(
                .GET,
                "\(BaseApiService.SERVER_BASE_URL)/topics/\(topicId)",
                encoding: .JSON,
                headers: self.headers
            ).responseObject { (response: Response<Topic, NSError>) in
                let topic = response.result.value
                fulfill(topic!)
            }
        }
    }

    
    func getParticipantsForTopic(topicId: String) -> Promise<ParticipantResponse> {
        return Promise { fulfill, reject in
            Alamofire.request(
                .GET,
                "\(BaseApiService.SERVER_BASE_URL)/topics/\(topicId)/participants",
                encoding: .JSON,
                headers: self.headers
            ).responseObject { (response: Response<ParticipantResponse, NSError>) in
                let participantResponse = response.result.value
                fulfill(participantResponse!)
            }
        }
    }
    
    func createTopic(name: String) -> Promise<Topic> {
        return Promise { fulfill, reject in
            Alamofire.request(
                .POST,
                "\(BaseApiService.SERVER_BASE_URL)/topics",
                parameters: [
                    "name": name
                ],
                encoding: .JSON,
                headers: self.headers
            ).responseObject { (response: Response<Topic, NSError>) in
                let topic = response.result.value
                fulfill(topic!)
            }
        }
    }

    func updateTopic(topic: Topic) -> Promise<Topic> {
        return Promise { fulfill, reject in
            Alamofire.request(
                .PUT,
                "\(BaseApiService.SERVER_BASE_URL)/topics/\(topic._id!)",
                parameters: [
                    "_id": topic._id!,
                    "active": topic.active!
                ],
                encoding: .JSON,
                headers: self.headers
            ).responseObject { (response: Response<Topic, NSError>) in
                let topic = response.result.value
                fulfill(topic!)
            }
        }
    }
    
    func addPhotoToTopic(topicId: String, photo: UIImage, description: String) -> Promise<Bool> {
        let url = "\(BaseApiService.SERVER_BASE_URL)/topics/\(topicId)"
        return Promise { fulfill, reject in
            Alamofire.upload(
                .POST,
                url,
                headers: self.headers,
                multipartFormData: { multipartFormData in
                    if let _photoData = UIImageJPEGRepresentation(photo, 0.7) {
                        multipartFormData.appendBodyPart(data: _photoData, name: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
                    }
                    multipartFormData.appendBodyPart(data: description.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "description")
                },
                encodingCompletion: { encodingResult in
                    print(encodingResult)
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        print(upload)
                        upload.responseJSON { response in
                            let statusCode = (response.response)!.statusCode
                            fulfill(statusCode == 200)
                        }
                    case .Failure(let fail):
                        reject(fail)
                    }
                }
            )
        }
    }
}

