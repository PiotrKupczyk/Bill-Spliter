//
// Created by Piotr Kupczyk on 2019-02-18.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit

class FancyTextField: UIView {
    private var bottomConstraint: Constraint? = nil
    public private(set) var isActive = false
    private let placeholderLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.appFont(ofSize: 13, weight: .regular)
        l.textColor = UIColor.textLightGray
        return l
    }()

    private let underlineView: UIView = {
        let v = UIView()
        v.backgroundColor = .textLightGray
        return v
    }()

    let textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.appFont(ofSize: 13, weight: .demiBold)
        tf.textColor = UIColor.coolBlue
        return tf
    }()

    private func setupLayouts() {
        addSubview(underlineView)
        underlineView.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(1)
        }
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            bottomConstraint = maker.bottom.equalTo(underlineView.snp.top).constraint
            maker.top.equalToSuperview()
        }
        bottomConstraint?.activate()
    }

    public func showTextField() {
        self.addSubview(self.textField)
        self.textField.snp.makeConstraints { maker in
            maker.top.equalTo(self.placeholderLabel.snp.bottom).inset(4)
            maker.leading.equalToSuperview().inset(4)
            maker.trailing.equalToSuperview()
            maker.bottom.equalTo(self.underlineView.snp.top)
        }
        self.bottomConstraint?.deactivate()
        self.setNeedsUpdateConstraints()

        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
            self.placeholderLabel.textColor = UIColor.coolBlue
            self.underlineView.backgroundColor = UIColor.coolBlue
            self.placeholderLabel.font = UIFont.appFont(ofSize: 13, weight: .regular)
            self.layoutIfNeeded()
        })
        self.isActive = !self.isActive
        textField.becomeFirstResponder()
    }
    public func hideTextField() {
        if ((self.textField.text?.isEmpty)!) {
            self.isActive = !self.isActive
            bottomConstraint?.activate()
            textField.removeFromSuperview()
            self.setNeedsUpdateConstraints()

            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                self.placeholderLabel.textColor = UIColor.textLightGray
                self.underlineView.backgroundColor = UIColor.textLightGray
                self.placeholderLabel.transform = self.placeholderLabel.transform.inverted()
                self.layoutIfNeeded()
            }, completion: {
                _ in
                self.placeholderLabel.font = UIFont.appFont(ofSize: 13, weight: .regular)
            })

        } else {
            self.placeholderLabel.textColor = .black
            self.underlineView.backgroundColor = .black
            self.textField.textColor = .black
        }
        textField.resignFirstResponder()
    }

    init(placeholder: String, type: UIKeyboardType = .default) {
        super.init(frame: .zero)
        setupLayouts()
        placeholderLabel.text = placeholder
        self.textField.keyboardType = type
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}