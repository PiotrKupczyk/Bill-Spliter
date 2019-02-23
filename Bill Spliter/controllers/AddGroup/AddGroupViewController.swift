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

class AddGroupViewController: KeyboardFriendlyVC, UICollectionViewDelegateFlowLayout {
    public var viewModel: AddGroupViewModel!
    var disposeBag = DisposeBag()

    convenience init(viewModel: AddGroupViewModel) {
        self.init()
        self.viewModel = viewModel
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
        bindTittleTextField()
        bindCurrencyTextField()
        bindGestureRecognizer()
        bindCollectionView()
        bindAddMembersButton()
        bindSubmitButton()
    }

    private func setupViews() {
        collectionView.backgroundColor = .white
        scrollView.backgroundColor = .white
        self.view.backgroundColor = .white

        collectionView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)
        collectionView.register(MembersCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
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

    private func bindGestureRecognizer() {
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
                    (_, member: User, cell: MembersCollectionViewCell) in
                    cell.userModel = member
                    cell.rx
                            .swipeGesture(.left)
                            .when(.ended)
                            .subscribe(onNext: { recognizer in
                                let cell = recognizer.view as! MembersCollectionViewCell
                                self.viewModel?.removeUser(user: cell.userModel)
                            })
                            .disposed(by: self.disposeBag)
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

    private func bindSubmitButton() {
        submitButton.rx
                    .tap
                    .subscribe(onNext: {
                        self.viewModel.createGroup(title: self.titleTextField.textField.text!, currency: "PLN")
                        self.navigationController?.popViewController(animated: true)
                    })
                    .disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width - 32, height: 38)
    }

    private func prepareNavigationToAddFriends() {
        let friendsViewModel = FriendViewModel()
        let friendsVC = FriendsViewController(viewModel: friendsViewModel)
        friendsViewModel.didSubmit
                        .subscribe(onNext: {
//                            [weak self] in self?.dismiss(animated: true)
//                            _ = users.element?.map { self.viewModel.addUser(user: $0)

                            self.navigationController?.popViewController(animated: true)
                        })
                        .disposed(by: friendsVC.disposeBag)

        friendsViewModel.didSelect
                        .subscribe(onNext: { user in
                            self.viewModel.addUser(user: user)
                        })
                        .disposed(by: friendsVC.disposeBag)


        friendsViewModel.didDeSelect
                .subscribe(onNext: { user in
                    self.viewModel.removeUser(user: user)
                })
                .disposed(by: friendsVC.disposeBag)

        friendsViewModel.didCancel
                        .subscribe(onNext: {
                            self.viewModel.removeAllUsers()
//                            self.navigationController?.popViewController(animated: true)
                        })
                        .disposed(by: friendsVC.disposeBag)

        navigationController?.rx.willShow.bind { controller, animated in
            print("wilShow")
        }.disposed(by: friendsVC.disposeBag)

//        self.present(friendsVC, animated: true)
        self.navigationController?.pushViewController(friendsVC, animated: true)
    }
}
