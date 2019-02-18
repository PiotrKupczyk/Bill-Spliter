//
//  BillsCollectionViewCell.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 14/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class BillsCollectionViewCell: UICollectionViewCell {
    var billModel: Bill! {
        didSet {
            imageView.kf.setImage(with: billModel.imageURL)
            titleLabel.text = billModel.tittle
            hourLabel.text = "19:52"
            nameLabel.text = billModel.name
            priceLabel.text = billModel.price
            setupLayouts()
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 64/2
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
        imageView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(snp.leading).inset(16)
            maker.top.equalTo(snp.top).inset(8)
//            maker.bottom.equalTo(snp.bottom).inset(16)
            maker.width.equalTo(64)
            maker.height.equalTo(64)
        }
        addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(snp.trailingMargin).inset(16)
            maker.top.equalTo(snp.top).inset(8)
            maker.centerY.equalTo(snp.centerY)
//            maker.bottom.equalTo(snp.bottom).inset(16)
            maker.width.equalTo(100)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(imageView.snp.trailing).inset(-16)
            maker.trailing.equalTo(priceLabel.snp.leading).inset(4)
            maker.top.equalTo(snp.top).inset(8)
            maker.height.equalTo(25)
        }
        addSubview(hourLabel)
        hourLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).inset(-8)
            maker.leading.equalTo(imageView.snp.trailing).inset(-16)
            maker.trailing.equalTo(priceLabel.snp.leading).inset(4)
//            maker.height.equalTo(18)
        }
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(imageView.snp.trailing).inset(-16)
            maker.top.equalTo(hourLabel.snp.bottom).inset(-4)
            maker.bottom.equalTo(snp.bottom).inset(8)
            maker.trailing.equalTo(priceLabel.snp.leading).inset(4)
        }
    }
}
