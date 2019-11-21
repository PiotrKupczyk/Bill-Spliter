//
// Created by Piotr Kupczyk on 28/10/2019.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

class SummaryViewController: UIViewController, UITableViewDelegate {
    private let reuseIdentifier = "SummaryCell"
    private let bag = DisposeBag() // TODO

    var members: [Member]!
    var viewModel: SummaryViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SummaryTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
        bindTableView()
        viewModel.calculateBalance(members: members)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    func bindTableView() {
        viewModel.dataSource.bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier)) {
            (_, balance: Balance, cell: SummaryTableViewCell) in
            cell.balanceModel = balance
        }.disposed(by: bag)
    }
    // Views setup

    private func setupView() {
        view.backgroundColor = .blue
        tableView.rx.setDelegate(self).disposed(by: bag)
    }

    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.top.trailing.bottom.leading.equalToSuperview()
        }
    }


    // Views

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        return tableView
    }()

}
