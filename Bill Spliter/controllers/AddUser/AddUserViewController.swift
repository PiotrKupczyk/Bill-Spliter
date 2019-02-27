//
//  AddUserViewController.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 10/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AddUserViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    var viewModelFactory: (AddUserViewModelViewModel.UIInputs) -> AddUserViewModelViewModel
            = { _ in fatalError("Must provide factory function first.") }

    private let reuseIdentifier = "friendsCell"
    let disposeBag = DisposeBag()
    private var viewModel: AddUserViewModelViewModel!
    var sth: Observable<Bool>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupViews()
        setupLayouts()
        bindCollectionView()
        bindSubmitButton()
        viewModel.fetchData()
    }

    private func setupViewModel() {
        let inputs = AddUserViewModelViewModel.UIInputs(
                selectUser: collectionView.rx.modelSelected(User.self).asObservable(),
                deSelectUser: collectionView.rx.modelDeselected(User.self).asObservable(),
                submitTrigger: submitButton.rx.tap.asObservable(),
                typingTrigger: searchBarView.searchTextField.rx.text.orEmpty.asObservable()
        )
        viewModel = viewModelFactory(inputs)
    }

    //MARK: - Views setup

    private func setupViews() {
        collectionView.allowsMultipleSelection = true
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        collectionView.register(AddUserCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    private func setupLayouts() {
        view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.snp.topMargin).inset(4)
            maker.leading.equalTo(view.snp.leading)
            maker.trailing.equalTo(view.snp.trailing)
            maker.height.equalTo(40)
        }
        view.addSubview(searchBarView)
        searchBarView.snp.makeConstraints { (maker) in
            maker.top.equalTo(subTitleLabel.snp.bottom).inset(-8)
            maker.leading.equalTo(view.snp.leading).inset(16)
            maker.trailing.equalTo(view.snp.trailing).inset(16)
            maker.height.equalTo(40)
        }
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(view.snp.bottomMargin).inset(16)
            maker.height.equalTo(50)
            maker.width.equalTo(200)
            maker.centerX.equalTo(view.snp.centerX)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(searchBarView.snp.bottom).inset(-16)
            maker.leading.equalTo(view.snp.leading).inset(16)
            maker.trailing.equalTo(view.snp.trailing).inset(16)
            maker.bottom.equalTo(submitButton.snp.top).inset(-16)
        }
    }

    public func bindCollectionView() {

        viewModel.usersObservable
                .bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier)) {
                    (row: Int , user: User, cell: AddUserCollectionViewCell) in
                        cell.userModel = user
                        if self.viewModel.isSelected(user: user) {
                            cell.isSelected = true
                            self.collectionView.selectItem(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
                        }
                    }
                .disposed(by: disposeBag)
    }

    public func bindSubmitButton() {
        //Enable button when any user is chosen
        viewModel.isSubmitEnabled
                 .bind(to: self.submitButton.rx.isEnabled)
                 .disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 140)
    }

    //MARK: - Custom views declaration
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(ofSize: 13, weight: .regular)
        label.text = "Find your friends using name or email."
        label.textColor = UIColor.textLightGray
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()

    let searchBarView = SearchBar()

    let submitButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(hexString: "#007AFF")
        btn.layer.cornerRadius = 25
        btn.setTitle("Submit", for: .normal)
        btn.titleLabel?.font = UIFont.appFont(ofSize: 16, weight: .bold)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowOffset = CGSize(width: 0, height: 3)

        return btn
    }()
}
