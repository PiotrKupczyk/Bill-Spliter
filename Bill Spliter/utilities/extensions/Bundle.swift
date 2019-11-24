//
// Created by Piotr Kupczyk on 24/11/2019.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import UIKit
import Foundation

extension Bundle {

    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }

        fatalError("Could not load view with type " + String(describing: type))
    }
}