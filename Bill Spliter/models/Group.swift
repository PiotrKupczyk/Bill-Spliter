//
//  Group.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 10/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation

struct Group: Codable {
    let id: String
    let name: String
    let imageURL: String?
    let members: [Member]
}

struct Member: Codable {
    let spends: [Spend]
    let userId: String
}
