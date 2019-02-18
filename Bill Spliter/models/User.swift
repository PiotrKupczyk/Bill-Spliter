//
//  User.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 12/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
class User {
    private let image: String
    private let privName: String
    private let friendsIds: [String] = [String]()
    
    init(imageURL: String, name: String) {
        self.image = imageURL
        self.privName = name
    }
}
extension User {
    var imageURL: URL? {
        return URL(string: image)
    }
    
    var name: String {
        return privName
    }
}

