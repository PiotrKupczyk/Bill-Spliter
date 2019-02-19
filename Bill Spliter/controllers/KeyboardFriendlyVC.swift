//
// Created by Piotr Kupczyk on 2019-02-18.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import RxGesture
import RxCocoa
import RxSwift

class KeyboardFriendlyVC: UIViewController {
    private let disposeBag = DisposeBag()
    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView()
    private var defaultHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupLayouts()
    }



    private func setupLayouts() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { maker in
            maker.leading.trailing.top.bottom.equalToSuperview()
//            maker.leadingMargin.trailingMargin.topMargin.bottomMargin.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { maker in
            maker.top.leading.trailing.bottom.centerX.equalToSuperview()
            maker.width.height.equalTo(view)
//            maker.height.equalTo(view.frame.height - view.safeAreaInsets.top-view.safeAreaInsets.bottom)
//            maker.width.equalTo(view.frame.width - view.safeAreaInsets.left*2)
        }
        contentView.backgroundColor = .white
        defaultHeight = view.frame.height
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let animationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        print(animationDuration)
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.size.height == defaultHeight {
                UIView.animate(withDuration: animationDuration, delay: 0, options: UIView.AnimationOptions(rawValue: animationCurve), animations: {
                    self.view.frame.size.height -= keyboardSize.height
                })
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.size.height != defaultHeight {
            self.view.frame.size.height = defaultHeight
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
