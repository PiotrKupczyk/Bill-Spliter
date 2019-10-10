//
//  User.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 12/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
struct User : Decodable, Encodable {
    let id: String
    let name: String
    let imageURL: String
    let groups: [String]
    let friends: [String]
}