//
//  Bill .swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 14/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation

class Bill {
    private let privImageURL: String
    private let privTittle: String
    private let privDateOfAddition: Double
    private let privName: String
    private let privPrice: Double
    
    init(imageURL: String, tittle: String, dateofAddition: Double, name: String, price: Double) {
        self.privImageURL = imageURL
        self.privTittle = tittle
        self.privDateOfAddition = dateofAddition
        self.privName = name
        self.privPrice = price
    }
}

extension Bill {
    public var imageURL: URL? {
        return URL(string: privImageURL) ?? URL(string: "any placeholder image")
    }
    
    public var tittle: String {
        return privTittle
    }
    
    public var dateOfAddition: Date {
        let timeInterval = TimeInterval(exactly: privDateOfAddition)
        return Date(timeIntervalSince1970: timeInterval ?? 0)
    }
    
    public var name: String {
        return privName
    }
    
    public var price: String {
        return "\(privPrice)zł"
    }
}
