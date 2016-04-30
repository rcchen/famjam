//
//  AnonymousApiService.swift
//  FamJam
//
//  Created by Roger Chen on 4/23/16.
//

import Alamofire
import Foundation

class AnonymousApiService: BaseApiService {
    
    static func createUser(username: String, password: String, displayName: String, cb: () -> Void) {
        Alamofire.request(
            .POST,
            "\(BaseApiService.SERVER_BASE_URL)/users",
            parameters: [
                "username": username,
                "password": password,
                "displayName": displayName,
            ],
            encoding: .JSON)
            .responseJSON { _ in
                cb()
        }
    }

    static func authenticateUser(username: String, password: String, cb: (Bool) -> Void) {        
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
                    cb(false)
                } else {
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setValue("Bearer \(response.result.value!)", forKey: BaseApiService.TOKEN_KEY)
                    defaults.synchronize()
                    cb(true)
                }
        }
    }
    
}