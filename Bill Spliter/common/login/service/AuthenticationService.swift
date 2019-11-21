//
// Created by Piotr Kupczyk on 25/10/2019.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_SwiftyJSON

struct TokenResponse : Encodable, Decodable {
    let token: String
    let expiresAfter: Int64
}

class AuthenticationService {
    static func authenticate(
            _ login: String,
            _ password: String,
            completion: @escaping (TokenResponse?) -> Void
    ) {
        let params = [
            "login" : login,
            "password" : password
        ]
        Alamofire.request("\(Const.API_PATH)/authenticate", parameters: params)
        .responseSwiftyJSON { response in
            guard let json = response.value else { print("Couldn't authenticate. Please check your network connection"); return }
            completion(json.decodeTo(TokenResponse.self))
        }

    }

    static func authHeader() -> [String: String] {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: Const.TOKEN_KEY) {
            return ["Authorization": token]
        } else { return ["":""] }
    }
}
