//
// Created by Piotr Kupczyk on 25/10/2019.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxGesture
import RxCocoa

class LoginViewController : UIViewController, UITextViewDelegate {

    private let disposeBag = DisposeBag()
    private var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        bindPasswordStartedTyping()
        setupViewModel()
        bindLoginStartedTyping()
        self.view.backgroundColor = .white
    }


    private func setupViewModel() {
        let inputs = LoginViewModel.UIInputs(
                loginTriggered: loginButton.rx.tap.asObservable(),
                loginTypingTriggered: loginTextField.textField.rx.text.orEmpty.asObservable(),
                passwordTypingTriggered: passwordTextField.textField.rx.text.orEmpty.asObservable()
        )
        viewModel = LoginViewModel(inputs: inputs)
        viewModel.authSuccessfully.subscribe(onNext: {
            self.prepareNavigationToGroupVC()
        }).disposed(by: disposeBag)

    }
    private func prepareNavigationToGroupVC() {
        let navVC = UINavigationController(rootViewController: MainTabBarController())
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.appFont(ofSize: 17, weight: .regular)]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = navVC

    }
    private func bindPasswordStartedTyping() {
        let view = passwordTextField as UIView
        view.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { gesture in
                    if !self.passwordTextField.isActive {
                        self.passwordTextField.showTextField()
                    }
                })
                .disposed(by: disposeBag)

        passwordTextField.textField.rx
                .controlEvent(.editingDidEndOnExit)
                .subscribe(onNext: {
                    self.passwordTextField.hideTextField()
                })
                .disposed(by: disposeBag)
    }
    private func bindLoginStartedTyping() {
        let view = loginTextField as UIView
        view.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { gesture in
                    if !self.loginTextField.isActive {
                        self.loginTextField.showTextField()
                    }
                })
                .disposed(by: disposeBag)

        loginTextField.textField.rx
                .controlEvent(.editingDidEndOnExit)
                .subscribe(onNext: {
                    self.loginTextField.hideTextField()
                })
                .disposed(by: disposeBag)
    }


    // Views below

    private let loginTextField = FancyTextField(placeholder: "Enter Login")
    private let passwordTextField = FancyTextField(placeholder: "Enter Password")
    private let applicationLogoImageView = UIImageView(image: UIImage(named: "for now nothing"))
    private let loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = UIColor(hexString: "#007AFF")
        btn.layer.cornerRadius = 25

        btn.titleLabel?.font = UIFont.appFont(ofSize: 16, weight: .bold)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowOffset = CGSize(width: 0, height: 3)
        return btn
    }()

    private func setupLayouts() {
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(applicationLogoImageView)
        view.addSubview(loginButton)

        applicationLogoImageView.snp.makeConstraints { maker in
            maker.centerX.equalTo(view.snp.centerX)
            maker.top.equalTo(view.snp.topMargin)
            maker.height.equalTo(64)
            maker.width.equalTo(64)
        }
        loginTextField.snp.makeConstraints { maker in
            maker.top.equalTo(applicationLogoImageView.snp.bottom).inset(16)
            maker.leading.equalTo(view.snp.leading).inset(16)
            maker.trailing.equalTo(view.snp.trailing).inset(16)
            maker.height.equalTo(48)
        }
        passwordTextField.snp.makeConstraints { maker in
            maker.top.equalTo(loginTextField.snp.bottom).offset(16)
            maker.leading.equalTo(view.snp.leading).inset(16)
            maker.trailing.equalTo(view.snp.trailing).inset(16)
            maker.height.equalTo(48)
        }
        loginButton.snp.makeConstraints { maker in
            maker.height.equalTo(50)
            maker.top.equalTo(passwordTextField.snp.bottom).offset(32)
            maker.leading.equalTo(view.snp.leading).offset(50)
            maker.trailing.equalTo(view.snp.trailing).offset(-50)
        }

    }
}
