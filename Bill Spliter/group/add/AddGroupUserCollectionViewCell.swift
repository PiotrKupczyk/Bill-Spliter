//
// Created by Piotr Kupczyk on 2019-02-19.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class AddGroupUserCollectionViewCell: UICollectionViewCell {
    var userModel: User! {
        didSet {
            guard let imageURL = URL(string: userModel.imageURL) else { return }
            nameLabel.text = userModel.name
            profileImageView.kf.setImage(with: imageURL)
        }
    }
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 30/2
        iv.clipsToBounds = false
        iv.layer.masksToBounds = true
        return iv
    }()

    let nameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.appFont(ofSize: 13, weight: .demiBold)
        return l
    }()
    //TODO fix streched image
    override func layoutSubviews() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { maker in
            maker.leading.top.equalToSuperview().offset(4)
            maker.bottom.equalToSuperview().offset(-4)
            maker.width.equalTo(30)
        }
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(profileImageView.snp.trailing).offset(8)
            maker.top.equalToSuperview().offset(4)
            maker.bottom.trailing.equalToSuperview().offset(-4)
        }
    }
}