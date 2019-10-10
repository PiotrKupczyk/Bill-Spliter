//
// Created by Piotr Kupczyk on 07/10/2019.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_SwiftyJSON

struct UserService {
    static func getUserFriends(userId: String, completion: @escaping ([User]) -> Void) {
        Alamofire.request(
                        "\(Const.API_PATH)/user",
                        parameters: ["userId": userId]
                )
                .responseSwiftyJSON { response in
                    guard let json = response.value else {
                        return
                    }
                    completion(json.decodeTo([User].self) ?? [])
                }
    }

    static func getUsers(completion: @escaping ([User]) -> Void) {
        Alamofire.request("\(Const.API_PATH)/user")
                .responseSwiftyJSON { response in
                    guard let json = response.value else {
                        print("Error during fetching users")
                        return
                    }
                    completion(json.decodeTo([User].self) ?? [])
                }
    }

    static func createUser(userName: String, completion: @escaping (User?) -> Void) {
        Alamofire.request("\(Const.API_PATH)/user", method: .post)
                .responseSwiftyJSON { response in
                    guard let json = response.value else {
                        return
                    }
                    completion(json.decodeTo(User.self))
                }
    }
}