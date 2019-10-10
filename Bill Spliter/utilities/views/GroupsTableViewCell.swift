//
//  BillsTableViewCell.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 10/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import UIKit
import SnapKit

class GroupsTableViewCell: UITableViewCell {
    var groupModel: Group! {
        didSet {
            if let imageURL = URL(string: groupModel.imageURL ?? "") {
                iconImageView.kf.setImage(with: imageURL)
            } else {
                iconImageView.image = UIImage(named: "home-icon")
            }
            titleLabel.text = groupModel.name
            balanceLabel.text = "0zł"
            setupLayouts()
            setupViews()
        }
    }
    
    let iconImageView = UIImageView(frame: .zero)
    let titleLabel = UILabel(frame: .zero)
    let balanceLabel = UILabel(frame: .zero)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayouts()
        setupViews()
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    private func setupLayouts() {
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp_centerYWithinMargins)
            maker.leading.equalTo(self.snp_leadingMargin).inset(-8)
            maker.width.equalTo(64)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(iconImageView.snp_trailingMargin).inset(-32)
            maker.centerY.equalTo(self.snp_centerYWithinMargins)
            maker.width.equalTo(120)
        }
        
        self.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp_centerYWithinMargins)
            maker.trailing.equalTo(self.snp_trailingMargin).inset(8)
            maker.leading.equalTo(self.snp_leadingMargin)
        }
    }
    
    private func setupViews() {
        titleLabel.font = UIFont.appFont(ofSize: 22, weight: .regular)
        titleLabel.numberOfLines = 2
        balanceLabel.font = UIFont.appFont(ofSize: 22, weight: .bold)
        balanceLabel.textAlignment = .right
        selectionStyle = .none
    }
}
