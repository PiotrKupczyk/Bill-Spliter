//
// Created by Piotr Kupczyk on 28/10/2019.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import UIKit
import SnapKit

class SummaryTableViewCell: UITableViewCell {
    var balanceModel: Balance! {
        didSet {
            if let imageURL = URL(string: balanceModel.debtorImage) {
                iconImageView.kf.setImage(with: imageURL)
            } else {
                iconImageView.image = UIImage(named: "home-icon")
            }
            titleLabel.text = "\(balanceModel.debtor) owns \(balanceModel.userName)"
            balanceLabel.text = String(format: "%.2f EUR", balanceModel.value)
            setupLayouts()
            setupViews()
        }
    }

    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 56 / 2
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true

        return iv
    }()
    let titleLabel = UILabel(frame: .zero)
    let balanceLabel = UILabel(frame: .zero)

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayouts()
        setupViews()
    }

    private func setupLayouts() {
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview().inset(8)
            maker.leading.equalTo(self.snp_leadingMargin).inset(-8)
            maker.width.equalTo(56)
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
        titleLabel.font = UIFont.appFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 2
        balanceLabel.font = UIFont.appFont(ofSize: 16, weight: .regular)
        balanceLabel.textAlignment = .right
        selectionStyle = .none
    }

}

