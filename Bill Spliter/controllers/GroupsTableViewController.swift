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
    private let reuseIdentifier = "GroupsCell"
    let model = GroupViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        setupView()
        setupLayouts()
        bindTableView()

        model.fetchData()
    }
    
    let plusButton = UIButton()
    let tableView = UITableView()
    
    private func setupView() {
        plusButton.setImage(UIImage(named: "plus-icon"), for: .normal)
        view.backgroundColor = .white
        self.tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        plusButton.rx
                .tap
                .subscribe(onNext: {
                    let vc = AddGroupViewController()
                    vc.title = "Add group"
                    self.navigationController?.pushViewController(vc, animated: true)
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
    
    private func bindTableView() {
        model.dataSource.bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier)) {
            (_, group: Group, cell: GroupsTableViewCell) in
            cell.groupModel = group
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: {
            (indexPath) in
            do {
                let group = try self.model.dataSource.value()[indexPath.row]
                let vc = BillsViewController()
                vc.title = "\(group.title) bills"
                self.navigationController?.pushViewController(vc, animated: true)
            } catch {
                fatalError()
            }
        }).disposed(by: disposeBag)
    }

    // MARK: - Table view data sourc
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    private func addPlusButton() {
//        view.addSubview(plusButton)
        tableView.addSubview(plusButton)
//        plusButton.backgroundColor = .red
        plusButton.superview?.bringSubviewToFront(plusButton)
//        plusButton.layer.zPosition = 99999
//        parent?.view.bringSubviewToFront(plusButton)
        plusButton.frame = CGRect(origin: CGPoint(x: 161, y: 591), size: CGSize(width: 54, height: 54))
        plusButton.setImage(UIImage(named: "plusButton"), for: .normal)
//        plusButton.snp.makeConstraints { (maker) in
//            maker.centerX.equalTo(view.snp.centerX)
////            maker.bottom.equalTo(view.snp.bottom).inset(22)
//            maker.width.equalTo(54)
//            maker.height.equalTo(54)
//        }
        
    }
}
