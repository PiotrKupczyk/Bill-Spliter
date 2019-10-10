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

extension GroupsTableViewController {
    func createGroup(_ group: Group) {
        viewModel.appendGroup(group: group)
    }
}

class GroupsTableViewController: UIViewController, UITableViewDelegate {
    private let reuseIdentifier = "GroupsCell"
    let viewModel = GroupViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

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
                    .subscribe(onNext: {
                        print("Submitted group creation")
                        self.navigationController?.popViewController(animated: true)
                    })
                    .disposed(by: groupViewModel.bag)
            groupViewModel.didGroupCreated
                    .subscribe(onNext: { group in
                        guard let safeGroup = group else { return }
                        self.viewModel.appendGroup(group: safeGroup)
                    }).disposed(by: groupViewModel.bag)
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
        viewModel.dataSource.bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier)) {
            (_, group: Group, cell: GroupsTableViewCell) in
            cell.groupModel = group
        }.disposed(by: disposeBag)

        tableView.rx.itemSelected.subscribe(onNext: {
            (indexPath) in
                let group = self.viewModel.dataSource.value[indexPath.row]
                let vc = GroupBillsViewController(group: group)
                vc.title = "\(group.name) bills"
                self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }

    private func setupView() {
        plusButton.setImage(UIImage(named: "plus-icon"), for: .normal)
        view.backgroundColor = .white
        self.tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        plusButton.rx
                .tap
                .subscribe(onNext: {
                    self.prepareNavigationToAddGroup()
                })
                .disposed(by: disposeBag)
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
