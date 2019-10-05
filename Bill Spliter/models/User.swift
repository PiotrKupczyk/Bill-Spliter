//
//  User.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 12/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
class User {
    private let _id: String
    private let image: String
    private let _name: String
    private let friendsIds: [String] = [String]()
    
    init(id: String, imageURL: String, name: String) {
        self.image = imageURL
        self._name = name
        _id = id

    }
}
extension User {
    var id: String {
        return _id
    }

    var imageURL: URL? {
        return URL(string: image)
    }
    
    var name: String {
        return _name
    }
}

