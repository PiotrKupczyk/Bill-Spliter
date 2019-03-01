//
//  BillsTableViewController.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 10/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class GroupsTableViewController: UIViewController, UITableViewDelegate {
    var viewModelFactory: (GroupViewModel.UIInputs) -> GroupViewModel
            = { _ in fatalError("Must provide factory function first.") }

    private let reuseIdentifier = "GroupsCell"
    private var viewModel: GroupViewModel!
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        let inputs = GroupViewModel.UIInputs(
                groupSelected: tableView.rx.modelSelected(Group.self).asObservable()
        )

        viewModel = viewModelFactory(inputs)

        tableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        setupView()
        setupLayouts()
        bindTableView()

        viewModel.fetchData()
    }

    let plusButton = UIButton()
    let tableView = UITableView()

    private func prepareNavigationToAddGroup() {
        let addGroupVC = AddGroupViewController()
        addGroupVC.viewModelFactory = { inputs in
            let groupViewModel = AddGroupViewModel(inputs: inputs)
            groupViewModel.didSubmit
                            .subscribe(onNext: { group in
                                self.viewModel.addGroup(group: group)
                                self.navigationController?.popViewController(animated: true)
                            })
                            .disposed(by: groupViewModel.bag)
            return groupViewModel
        }

        addGroupVC.title = "Add group"

        self.navigationController?.pushViewController(addGroupVC, animated: true)
    }



    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    private func addPlusButton() {
        tableView.addSubview(plusButton)
        plusButton.superview?.bringSubviewToFront(plusButton)
        //TODO fix button position
        plusButton.frame = CGRect(origin: CGPoint(x: 161, y: 591), size: CGSize(width: 54, height: 54))
        plusButton.setImage(UIImage(named: "plusButton"), for: .normal)
    }

    private func bindTableView() {
        viewModel.groups.bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier)) {
            (_, group: Group, cell: GroupsTableViewCell) in
            cell.groupModel = group
        }.disposed(by: bag)

        tableView.rx.modelSelected(Group.self)
                    .subscribe(onNext: { group in
                        let vc = GroupBillsViewController()
                        vc.title = "\(group.title) bills"
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                    .disposed(by: bag)
    }

    private func setupView() {
        plusButton.setImage(UIImage(named: "plus-icon"), for: .normal)
        view.backgroundColor = .white
        self.tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.rx.setDelegate(self).disposed(by: bag)
        plusButton.rx
                .tap
                .subscribe(onNext: {
                    self.prepareNavigationToAddGroup()
                })
                .disposed(by: bag)
    }

    private func setupLayouts() {
        view.addSubview(plusButton)
        plusButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.height.equalTo(64)
            maker.width.equalTo(64)
            maker.bottom.equalTo(view.snp.bottomMargin).inset(8)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.snp.topMargin)
            maker.trailing.equalTo(view.snp.trailing)
            maker.leading.equalTo(view.snp.leading)
            maker.bottom.equalTo(plusButton.snp.top).inset(-8)
//            maker.bottom.equalTo(view.snp.bottomMargin)
        }
    }
}
