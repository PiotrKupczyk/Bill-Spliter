//
//  AddUserCollectionViewCell.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 12/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import UIKit
import Kingfisher
class AddUserCollectionViewCell: UICollectionViewCell {
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                self.select()
            } else {
                self.deSelect()
            }
            super.isSelected = newValue
        }
    }

    var userModel: User! {
        didSet {
            guard let imageURL = URL(string: userModel.imageURL) else { return }
            profileImageView.kf.setImage(with: imageURL)
            nameLabel.text = userModel.name
            setupLayouts()
        }
    }
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 75/2
        view.layer.masksToBounds = false
        view.clipsToBounds = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private func setupLayouts() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.height.equalTo(75)
            maker.width.equalTo(75)
            maker.top.equalTo(snp.top).inset(4)
        }
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(profileImageView.snp.bottom).inset(-4)
            maker.leading.equalTo(snp.leading).inset(4)
            maker.trailing.equalTo(snp.trailing).inset(4)
            maker.bottom.equalTo(snp.bottom).inset(4)
        }
    }

    public var wasSelected = false
}

extension AddUserCollectionViewCell {
    func select() {
        let borderLayer = CALayer()
        borderLayer.frame = self.bounds
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.borderColor = UIColor.coolBlue.cgColor
        borderLayer.borderWidth = 3
        borderLayer.cornerRadius = 16
        
        let blSize = borderLayer.frame.size
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(origin: CGPoint(x: blSize.width-24, y: blSize.height-24), size: CGSize(width: 30, height: 30))
        imageLayer.contents = UIImage(named: "confirm-icon")?.cgImage
        
        borderLayer.addSublayer(imageLayer)
        self.layer.addSublayer(borderLayer)
    }
    
    func deSelect() {
        if layer.sublayers!.count >= 4 {
            _ = layer.sublayers?.popLast()
        }
    }
}
