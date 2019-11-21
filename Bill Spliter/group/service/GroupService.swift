//
// Created by Piotr Kupczyk on 06/10/2019.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_SwiftyJSON
import RxSwift

struct GroupService {
    private let DEFAULT_GROUP_IMAGE_URL = "https://www.countryflags.io/es/flat/64.png"
    private let CURRENT_USER_ID = ""

    static func getGroups(completion: @escaping ([Group]) -> Void) {
        Alamofire.request("\(Const.API_PATH)/group", headers: AuthenticationService.authHeader())
                .responseSwiftyJSON { response in
                    guard let json = response.value else {
                        return
                    }
                    completion(json.decodeTo([Group].self) ?? [])
                }
    }

    static func addSpend(
            groupId: String,
            title: String,
            value: Double,
            payerId: String,
            concerns: [String],
            completion: @escaping (Spend?) -> Void
    ) {
        let parameters: [String: Any] = [
            "title": title,
            "value": value,
            "payerId": payerId,
            "concerns": concerns
        ]
        Alamofire.request(
                "\(Const.API_PATH)/group/\(groupId)/spend",
                method: .put,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: AuthenticationService.authHeader()
        ).responseSwiftyJSON { response in
            guard let json = response.value else {
                print("Can't get json from response: \(response)")
                return
            }
            completion(json.decodeTo(Spend.self))
        }

    }

    static func createGroup(name: String, usersIds: [String], completion: @escaping (Group?) -> Void) {
        let parameters: [String: Any] = [
            "name": name,
            "imageURL": Const.DEFAULT_IMAGE_URL,
            "membersIds": usersIds
        ]
        Alamofire.request(
                "\(Const.API_PATH)/group",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: AuthenticationService.authHeader()
        ).responseSwiftyJSON { response in
            guard let json = response.value else {
                print("Can't get json from response: \(response)")
                return
            }
            completion(json.decodeTo(Group.self))
        }
    }

}