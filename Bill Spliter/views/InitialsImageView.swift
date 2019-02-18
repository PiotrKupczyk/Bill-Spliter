//
//  InitialsImageView.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 10/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import UIKit

class InitialsImageView: UIView {
    private let textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    init(backgroundColor: UIColor, text: String, size: CGSize) {
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

