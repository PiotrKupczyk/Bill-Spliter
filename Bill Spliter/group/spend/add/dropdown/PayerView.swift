//
// Created by Piotr Kupczyk on 24/11/2019.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import RxCocoa
import RxSwift

class PayerView : UIView {
    private let payerDropDown = DropDown()
    let users = BehaviorRelay<[User]>(value: [])
    private let bag = DisposeBag()
    let selectedUser = PublishSubject<User>()

    let name: UILabel = {
       let l = UILabel()
        l.font = UIFont.appFont(ofSize: 13, weight: .demiBold)
        return l
    }()
    let image: UIImageView = {
       let i = UIImageView()
        i.layer.cornerRadius = 16.0
        i.layer.masksToBounds = false
        i.clipsToBounds = true
        return i
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
        setupDropDown()
        bindUsersChanged()
    }

    func show() {
        payerDropDown.show()
    }

    private func setupViews() {
        addSubview(image)
        addSubview(name)
        image.snp.makeConstraints { maker in
            maker.leading.bottom.top.equalToSuperview().inset(4)
            maker.width.equalTo(32)
        }
        name.snp.makeConstraints { maker in
            maker.trailing.bottom.top.equalToSuperview().inset(4)
            maker.leading.equalTo(image.snp.trailing).offset(8)
        }

    }

    private func bindUsersChanged() {
        users.subscribe(onNext: { users in
            self.payerDropDown.dataSource = users.map { $0.name }
            self.payerDropDown.selectRow(0)
            print(users)
            if users.count > 0 {
                let user = users[0]
                self.selectedUser.onNext(user)
                self.name.text = user.name
                self.image.kf.setImage(with: URL(string: user.imageURL))
            }
        }).disposed(by: bag)
    }

    private func setupDropDown() {
        payerDropDown.anchorView = self
        payerDropDown.dismissMode = .onTap
        payerDropDown.direction = .bottom
        payerDropDown.cellNib = UINib(nibName: "PayerDropDownCellNib", bundle: nil)
        payerDropDown.textFont = UIFont.appFont(ofSize: 13, weight: .demiBold)
        payerDropDown.backgroundColor = .white
        payerDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? PayerDropDownCell else { return }
            guard let imageView = cell.imageView else { return }
            imageView.layer.cornerRadius = 16.0
            imageView.layer.masksToBounds = false
            imageView.clipsToBounds = true
            let user = self.users.value[index]
            cell.optionLabel.text = user.name
            cell.userImageView.kf.setImage(with: URL(string: user.imageURL))
        } as! CellConfigurationClosure
        payerDropDown.selectionAction = { (index, _) in
            let user = self.users.value[index]
            self.selectedUser.onNext(user)
            self.name.text = user.name
            self.image.kf.setImage(with: URL(string: user.imageURL))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
