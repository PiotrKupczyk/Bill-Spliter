//
//  UILabel.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 10/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import UIKit

extension UIFont {
    public enum FontWeight: String {
        case bold = "AvenirNext-Bold"
        case demiBold = "AvenirNext-DemiBold"
        case regular = "AvenirNext-Regular"
    }
    
    public static func appFont(ofSize: CGFloat, weight: FontWeight) -> UIFont {
        return UIFont(name: weight.rawValue, size: ofSize)!
    }
}
