//
//  AddUserSearchBarView.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 11/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import UIKit

class SearchBar: UIView {
    
    let searchIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "search-icon")
        return iv
    }()
    
    let searchTextField: UITextField = {
        let tf = UITextField()
//        tf.textColor = UIColor.textLightGray
        tf.font = UIFont.appFont(ofSize: 15, weight: .regular)
        tf.placeholder = "Enter name or email"
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .white
        layer.borderColor = UIColor(hexString: "#707070").cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 20
        
        addSubview(searchIcon)
        searchIcon.snp.makeConstraints { (maker) in
            maker.leading.equalTo(snp.leading).inset(16)
            maker.top.equalTo(snp.top).inset(8)
            maker.bottom.equalTo(snp.bottom).inset(8)
            maker.width.equalTo(18)
        }
        addSubview(searchTextField)
        searchTextField.snp.makeConstraints { (maker) in
            maker.leading.equalTo(searchIcon.snp.trailing).inset(-16)
            maker.top.equalTo(snp.top).inset(8)
            maker.bottom.equalTo(snp.bottom).inset(8)
            maker.trailing.equalTo(snp.trailing).inset(16)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
