//
//  Bill .swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 14/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation

struct Spend: Decodable, Encodable {
    let imageURL: String
    let title: String
    let date: Int64
    let value: Double
}
