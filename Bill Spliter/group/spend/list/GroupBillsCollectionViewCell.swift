//
//  GroupBillsCollectionViewCell.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 14/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class GroupBillsCollectionViewCell: UICollectionViewCell {
    private let dateFormatter = DateFormatter()
    var spendModel: Spend! {
        didSet {
            dateFormatter.dateFormat = "MMM d, HH:mm"
            imageView.kf.setImage(with: URL(string: spendModel.imageURL))
            titleLabel.text = spendModel.title
            hourLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(spendModel.date/1000)))
            priceLabel.text = String(format: "%.2f EUR", spendModel.value)
            nameLabel.text = spendModel.userName
            setupLayouts()
        }
    }

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 64 / 2
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true
        return iv
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(ofSize: 18, weight: .demiBold)
        label.backgroundColor = .white
        return label
    }()

    let hourLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(ofSize: 13, weight: .demiBold)
        label.textColor = UIColor.textLightGray
        label.backgroundColor = .white
        return label
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(ofSize: 13, weight: .demiBold)
        label.backgroundColor = .white
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(ofSize: 22, weight: .bold)
        label.backgroundColor = .white
        label.textAlignment = .right
        return label
    }()

    private func setupLayouts() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(hourLabel)
        addSubview(nameLabel)
        addSubview(priceLabel)

        imageView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(snp.leading).inset(16)
            maker.top.equalTo(snp.top).inset(8)
//            maker.bottom.equalTo(snp.bottom).inset(16)
            maker.width.equalTo(64)
            maker.height.equalTo(64)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(imageView.snp.trailing).inset(-16)
            maker.trailing.equalTo(priceLabel.snp.leading).inset(4)
            maker.top.equalTo(snp.top).inset(8)
            maker.height.equalTo(25)
        }
        hourLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).inset(-4)
            maker.leading.equalTo(imageView.snp.trailing).inset(-16)
            maker.trailing.equalTo(priceLabel.snp.leading).inset(4)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(imageView.snp.trailing).inset(-16)
            maker.top.equalTo(hourLabel.snp.bottom).inset(-4)
            maker.bottom.equalTo(snp.bottom).inset(8)
            maker.trailing.equalTo(priceLabel.snp.leading).inset(4)
        }
        priceLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(snp.trailingMargin).inset(16)
            maker.centerY.equalTo(snp.centerY)
            maker.width.equalTo(150)
        }
    }
}
