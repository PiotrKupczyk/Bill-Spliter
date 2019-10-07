//
// Created by Piotr Kupczyk on 06/10/2019.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_SwiftyJSON

struct GroupService {
    private let DEFAULT_GROUP_IMAGE_URL = "https://www.countryflags.io/es/flat/64.png"
    private let CURRENT_USER_ID = ""

    static func getGroups(completion: @escaping ([Group]) -> Void) {
        Alamofire.request("\(Const.API_PATH)/group")
                .responseSwiftyJSON { response in
                    guard let json = response.value else {
                        return
                    }
                    completion(json.decodeTo([Group].self) ?? [])
                }
    }

    static func createGroup(name: String, completion: @escaping (Group?) -> Void) {
        let CURRENT_USER_ID = ""
        let DEFAULT_GROUP_IMAGE_URL = "https://www.countryflags.io/es/flat/64.png"
        let parameters: [String: Any] = [
            "name": name,
            "imageURL": DEFAULT_GROUP_IMAGE_URL,
            "membersIds": [CURRENT_USER_ID]
        ]
        Alamofire.request(
                "\(Const.API_PATH)/group",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default
        ).responseSwiftyJSON { response in
            guard let json = response.value else {
                print("Can't get json from response: \(response)")
                return
            }
            completion(json.decodeTo(Group.self))
        }
    }

}