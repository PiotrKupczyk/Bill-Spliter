//
// Created by Piotr Kupczyk on 2019-02-19.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class MembersCollectionViewCell: UICollectionViewCell {
    var userModel: User! {
        didSet {
            nameLabel.text = userModel.name
            profileImageView.kf.setImage(with: userModel.imageURL)
        }
    }
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()

    let nameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.appFont(ofSize: 13, weight: .demiBold)
        l.backgroundColor = .red
        return l
    }()
    //TODO fix streched image
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { maker in
            maker.leading.top.equalToSuperview().offset(4)
            maker.bottom.equalToSuperview().offset(-4)
        }
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(profileImageView.snp.trailing).offset(8)
            maker.top.equalToSuperview().offset(4)
            maker.bottom.trailing.equalToSuperview().offset(-4)
        }
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
    }
}