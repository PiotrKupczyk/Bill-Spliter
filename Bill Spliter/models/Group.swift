//
//  Group.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 10/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation

class Group {
    private let privTitle: String
    private let privImageName: String
    private let privGroupBalance: Double
    private let privUsersIds: [String] = [String]()
    
    init(title: String, imageName: String, groupBalance: Double) {
        self.privTitle = title
        self.privImageName = imageName
        self.privGroupBalance = groupBalance
    }
}
extension Group {
    var title: String {
        return privTitle
    }
    var imageName: String {
        return privImageName
    }
    var groupBalance: String {
        return "\(privGroupBalance)zł"
    }

    var usersIds: [String] {
        return privUsersIds
    }
}
