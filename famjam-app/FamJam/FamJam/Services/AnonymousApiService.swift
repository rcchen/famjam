//
//  AnonymousApiService.swift
//  FamJam
//
//  Created by Roger Chen on 4/23/16.
//

import Alamofire
import BrightFutures
import Foundation

class AnonymousApiService: BaseApiService {

    enum AnonymousApiServiceError : ErrorType {
        case RequestFailed
    }

    static func createUser(username: String, password: String, displayName: String) -> Future<Bool, AnonymousApiServiceError> {
        let promise = Promise<Bool, AnonymousApiServiceError>()
        Queue.global.async {
            Alamofire.request(
                .POST,
                "\(BaseApiService.SERVER_BASE_URL)/users",
                parameters: [
                    "username": username,
                    "password": password,
                    "displayName": displayName,
                ],
                encoding: .JSON)
                .responseJSON { response in
                    let statusCode = (response.response)!.statusCode
                    if (statusCode == 200) {
                        promise.success(true)
                    }
            }
        }
        return promise.future
    }

    static func authenticateUser(username: String, password: String) -> Future<Bool, AnonymousApiServiceError> {
        let promise = Promise<Bool, AnonymousApiServiceError>()
        Queue.global.async {
            Alamofire.request(
                .POST,
                "\(BaseApiService.SERVER_BASE_URL)/authenticate",
                parameters: [
                    "username": username,
                    "password": password
                ],
                encoding: .JSON)
                .responseJSON { response in
                    let statusCode = (response.response)!.statusCode
                    if statusCode == 401 {
                        promise.success(false)
                    } else {
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setValue("Bearer \(response.result.value!)", forKey: BaseApiService.TOKEN_KEY)
                        defaults.synchronize()
                        promise.success(true)
                    }
            }
        }
        return promise.future
    }
    
}