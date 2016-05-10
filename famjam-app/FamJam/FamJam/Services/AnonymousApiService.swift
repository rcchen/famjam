//
//  AnonymousApiService.swift
//  FamJam
//
//  Created by Roger Chen on 4/23/16.
//

import Alamofire
import Foundation
import PromiseKit

class AnonymousApiService: BaseApiService {

    enum AnonymousApiServiceError : ErrorType {
        case RequestFailed
    }

    static func createUser(username: String, password: String, displayName: String) -> Promise<Void> {
        return Promise { fulfill, reject in
            Alamofire.request(
                .POST,
                "\(BaseApiService.SERVER_BASE_URL)/users",
                parameters: [
                    "username": username,
                    "password": password,
                    "displayName": displayName,
                ],
                encoding: .JSON
            ).responseJSON { data in
                let response = data.response!
                let statusCode = response.statusCode
                if (statusCode == 200) {
                    fulfill()
                } else {
                    reject(data.result.error!)
                }
            }
        }
    }

    static func authenticateUser(username: String, password: String) -> Promise<Void> {
        return Promise { fulfill, reject in
            Alamofire.request(
                .POST,
                "\(BaseApiService.SERVER_BASE_URL)/authenticate",
                parameters: [
                    "username": username,
                    "password": password
                ],
                encoding: .JSON
            ).responseJSON { data in
                let statusCode = (data.response)!.statusCode
                if statusCode == 401 {
                    reject(data.result.error!)
                } else {
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setValue("Bearer \(data.result.value!)", forKey: BaseApiService.TOKEN_KEY)
                    defaults.synchronize()
                    fulfill()
                }
            }
        }
    }

    static func logoutUser() -> Promise<Void> {
        return Promise { fulfill, reject in
            // HACKHACK: Just clears their token from NSUserDefaults
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.removeObjectForKey(BaseApiService.TOKEN_KEY)
            defaults.synchronize()
            fulfill()
        }
    }
}