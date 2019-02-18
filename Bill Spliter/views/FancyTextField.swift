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
    private let disposeBag = DisposeBag()
    private let placeholderLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.appFont(ofSize: 17, weight: .regular)
        l.textColor = UIColor.textLightGray
        return l
    }()

    private let underlineView: UIView = {
        let v = UIView()
        v.backgroundColor = .textLightGray
        return v
    }()

    private let textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.appFont(ofSize: 17, weight: .demiBold)
        return tf
    }()

    private func setupViews() {
        bindTextField()
        bindView()
    }

    private func bindTextField() {
        textField.rx
                 .controlEvent(.editingDidEndOnExit)
                 .subscribe(onNext: {
                     if ((self.textField.text?.isEmpty)!) {
                         self.hideTextField()
                     }
                     self.textField.resignFirstResponder()
                 })
                 .disposed(by: disposeBag)
    }

    private func bindView() {
        let view = self as UIView
        view.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { gesture in
                if !self.isActive {
                    self.showTextField()
                }
            })
            .disposed(by: disposeBag)
    }

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
            bottomConstraint = maker.bottom.equalTo(underlineView.snp.bottom).constraint
            maker.top.equalToSuperview()
        }
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

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.placeholderLabel.textColor = UIColor.coolBlue
            self.underlineView.backgroundColor = UIColor.coolBlue
            self.placeholderLabel.transform = CGAffineTransform(scaleX: 13/17, y: 13/17).translatedBy(x: -55, y: 0)
            self.layoutIfNeeded()
        })
        self.isActive = !self.isActive
        textField.becomeFirstResponder()
    }

    public func hideTextField() {
        self.isActive = !self.isActive
        bottomConstraint?.activate()
        textField.removeFromSuperview()
        self.setNeedsUpdateConstraints()

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.placeholderLabel.textColor = UIColor.textLightGray
            self.underlineView.backgroundColor = UIColor.textLightGray
            self.placeholderLabel.transform = self.placeholderLabel.transform.inverted()
            self.layoutIfNeeded()
        })
        textField.resignFirstResponder()
    }

    init(placeholder: String) {
        super.init(frame: .zero)
        setupLayouts()
        setupViews()
        placeholderLabel.text = placeholder
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}