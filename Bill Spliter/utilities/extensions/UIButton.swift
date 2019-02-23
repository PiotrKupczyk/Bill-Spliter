//
// Created by Piotr Kupczyk on 2019-02-23.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import UIKit

extension UIButton {
    open override var isEnabled: Bool {
        get {
            return super.isEnabled
        }
        set {
            if newValue {
                self.layer.opacity = 1.0
            } else {
                self.layer.opacity = 0.35
            }
            super.isEnabled = newValue
        }
    }
}