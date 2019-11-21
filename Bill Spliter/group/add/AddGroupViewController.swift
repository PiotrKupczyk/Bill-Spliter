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

class AddGroupViewController : KeyboardFriendlyVC, UICollectionViewDelegateFlowLayout {

    var viewModel: AddGroupViewModel!

    var viewModelFactory: (AddGroupViewModel.UIInputs) -> AddGroupViewModel
            = { _ in
        fatalError("Must provide factory function first.")
    }

    private func setupViewModel() {
        let inputs = AddGroupViewModel.UIInputs(
                submitTriggered: submitButton.rx.tap.asObservable(),
                titleTypingTriggered: titleTextField.textField.rx.text.orEmpty.asObservable(),
                currencyTypingTriggered: currencyTextField.textField.rx.text.orEmpty.asObservable()
        )
        viewModel = viewModelFactory(inputs)
    }

    let disposeBag = DisposeBag()
    var swipeBag = DisposeBag()

    private func bindTittleTextField() {
        let view = titleTextField as UIView
        view.rx
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { gesture in
                    if !self.titleTextField.isActive {
                        self.titleTextField.showTextField()
                    }
                })
                .disposed(by: disposeBag)

        titleTextField.textField.rx
                .controlEvent(.editingDidEndOnExit)
                .subscribe(onNext: {
                    self.titleTextField.hideTextField()
                })
                .disposed(by: disposeBag)
    }

    private func bindCurrencyTextField() {
        let view = currencyTextField as UIView
        view.rx
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { gesture in
                    if !self.currencyTextField.isActive {
                        self.currencyTextField.showTextField()
                    }
                })
                .disposed(by: disposeBag)

        currencyTextField.textField.rx
                .controlEvent(.editingDidEndOnExit)
                .subscribe(onNext: {
                    self.currencyTextField.hideTextField()
                })
                .disposed(by: disposeBag)
    }

    private func bindKeyboardDismissGesture() {
        contentView.rx
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { recognizer in
                    if self.currencyTextField.isActive {
                        self.currencyTextField.hideTextField()
                    }
                    if self.titleTextField.isActive {
                        self.titleTextField.hideTextField()
                    }
                })
                .disposed(by: disposeBag)
    }

    private func bindCollectionView() {
        viewModel.usersObservable
                .bind(to: collectionView.rx.items(cellIdentifier: identifier)) {
                    (_, member: User, cell: AddGroupUserCollectionViewCell) in
                    cell.userModel = member
                    cell.rx
                            .swipeGesture(.left)
                            .when(.ended)
                            .subscribe(onNext: { recognizer in
                                let cell = recognizer.view as! AddGroupUserCollectionViewCell
                                self.viewModel?.removeUser(user: cell.userModel)
                            })
                            .disposed(by: self.swipeBag)
                }.disposed(by: self.disposeBag)
    }

    private func bindAddMembersButton() {
        addMembersButton.rx
                .tap
                .subscribe(onNext: {
                    self.prepareNavigationToAddFriends()
                })
                .disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupViews()
        setupLayouts()
        bindTittleTextField()
        bindCurrencyTextField()
        bindKeyboardDismissGesture()
        bindCollectionView()
        bindAddMembersButton()
    }

    private let identifier = "cellId"
    let titleTextField = FancyTextField(placeholder: "Title")
    let currencyTextField = FancyTextField(placeholder: "Currency")
    let peopleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.appFont(ofSize: 13, weight: .regular)
        l.textColor = UIColor.textLightGray
        l.text = "Friends"
        return l
    }()

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    let addMembersButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "plus-icon"), for: .normal)
        return b
    }()

    let addMembersLabel: UILabel = {
        let l = UILabel()
        l.text = "Add friends"
        l.font = UIFont.appFont(ofSize: 17, weight: .regular)
        l.textColor = UIColor.textLightGray
        return l
    }()

    let submitButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(hexString: "#007AFF")
        btn.layer.cornerRadius = 25

        btn.setTitle("Add", for: .normal)
        btn.titleLabel?.font = UIFont.appFont(ofSize: 16, weight: .bold)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowOffset = CGSize(width: 0, height: 3)

        return btn
    }()

    private func setupViews() {
        collectionView.backgroundColor = .white
        scrollView.backgroundColor = .white
        self.view.backgroundColor = .white

        collectionView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)
        collectionView.register(AddGroupUserCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
    }

    private func setupLayouts() {
        contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { maker in
            maker.top.equalTo(contentView.snp.topMargin).inset(4)
            maker.leadingMargin.equalToSuperview().offset(16)
            maker.trailingMargin.equalToSuperview().offset(-16)
            maker.height.equalTo(48)
        }
        contentView.addSubview(currencyTextField)
        currencyTextField.snp.makeConstraints { maker in
            maker.top.equalTo(titleTextField.snp.bottom).inset(-16)
            maker.leadingMargin.equalToSuperview().offset(16)
            maker.trailingMargin.equalToSuperview().offset(-16)
            maker.height.equalTo(48)
        }
        contentView.addSubview(peopleLabel)
        peopleLabel.snp.makeConstraints { maker in
            maker.leadingMargin.equalToSuperview().offset(16)
            maker.trailingMargin.equalToSuperview().offset(-16)
            maker.top.equalTo(currencyTextField.snp.bottom).inset(-16)
        }
        contentView.addSubview(submitButton)
        submitButton.snp.makeConstraints { maker in
            maker.height.equalTo(50)
            maker.bottom.equalTo(view).offset(-32)
            maker.leading.equalToSuperview().offset(50)
            maker.trailing.equalToSuperview().offset(-50)
        }
        contentView.addSubview(addMembersButton)
        addMembersButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(16)
            maker.top.equalTo(peopleLabel.snp.bottom).offset(8)
            maker.width.height.equalTo(40)
        }
        contentView.addSubview(addMembersLabel)
        addMembersLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(addMembersButton.snp.trailing).offset(4)
            maker.top.bottom.equalTo(addMembersButton)
            maker.trailing.equalToSuperview().offset(-16)
        }
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().offset(-16)
            maker.top.equalTo(addMembersButton.snp.bottom).offset(8)
            maker.bottom.equalTo(submitButton.snp.top).offset(-8)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width - 32, height: 38)
    }

    private func prepareNavigationToAddFriends() {
        let addUserVC = AddUserViewController()

        addUserVC.viewModelFactory = { inputs in
            let addUserViewModel = AddUserViewModelViewModel(inputs)
            addUserViewModel.didSubmit
                    .subscribe(onNext: { users in
                        self.viewModel.updateUsers(with: users)
                        self.swipeBag = DisposeBag()
                        self.navigationController?.popViewController(animated: true)
                    })
                    .disposed(by: addUserVC.disposeBag)
            self.viewModel.usersObservable
                    .bind(to: addUserViewModel.selectedUsers)
                    .disposed(by: addUserViewModel.bag)
            return addUserViewModel
        }

        self.navigationController?.pushViewController(addUserVC, animated: true)
    }
}

