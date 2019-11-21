//
//  GroupBillsViewController.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 13/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class GroupBillsViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    private let resuseIdentifier = "cellId"
    let viewModel: GroupSpendsViewModel
    let disposeBag = DisposeBag()
    let group: Group

    let summaryButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "plus-icon"), for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
        bindCollectionView()
        viewModel.fetchData()
    }

    func navigateToSummary() {
        let vc = SummaryViewController()
        vc.members = group.members
        let summaryViewModel = SummaryViewModel(users: viewModel.users.value)
        vc.viewModel = summaryViewModel
        navigationController?.pushViewController(vc, animated: true)
    }

    init(group: Group) {
        self.group = group
        viewModel = GroupSpendsViewModel(group: group)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let plusButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "plus-button"), for: .normal)
        return btn
    }()
    private func prepareNavigationToAddSpend() {
        let addSpendVC = AddSpendViewController()
        addSpendVC.viewModelFactory = { inputs in
            let spendViewModel = AddSpendViewModel(inputs: inputs, group: self.group)
            spendViewModel.didSubmit
                    .subscribe(onNext: {
                        print("Submitted spend creation")
                        self.navigationController?.popViewController(animated: true)
                    })
                    .disposed(by: spendViewModel.bag)

            spendViewModel.didSpendCreated
                    .subscribe(onNext: { _spend in
                guard let spend = _spend else { return }
                    self.viewModel.addSpend(spend: spend)
            }).disposed(by: spendViewModel.bag)
            return spendViewModel
        }
        addSpendVC.title = "Add group"
        self.navigationController?.pushViewController(addSpendVC, animated: true)
    }

    func setupViews() {
        collectionView.register(GroupBillsCollectionViewCell.self, forCellWithReuseIdentifier: resuseIdentifier)
        collectionView.backgroundColor = .white
        view.backgroundColor = .white
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        setupPlusButton()

    }

    private func setupLayouts() {
        view.addSubview(plusButton)
        plusButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.height.equalTo(64)
            maker.width.equalTo(64)
            maker.bottom.equalTo(view.snp.bottomMargin).inset(8)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.snp.topMargin)
            maker.trailing.equalTo(view.snp.trailing)
            maker.leading.equalTo(view.snp.leading)
            maker.bottom.equalTo(plusButton.snp.top).inset(-8)
        }
        view.addSubview(summaryButton)
        summaryButton.snp.makeConstraints { maker in
            maker.height.equalTo(64)
            maker.width.equalTo(64)
            maker.leading.equalToSuperview()
            maker.bottom.equalTo(view.snp.bottomMargin).inset(8)
        }
        summaryButton.rx.tap.subscribe(onNext: {
                    self.navigateToSummary()
                })
                .disposed(by: disposeBag)
    }

    private func bindCollectionView() {
        viewModel.spends.bind(to: collectionView.rx.items(cellIdentifier: resuseIdentifier)) {
            (_, spend: Spend, cell: GroupBillsCollectionViewCell) in
            cell.spendModel = spend
        }.disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 80)
    }

    private func addPlusButton() {
        collectionView.addSubview(plusButton)
        plusButton.superview?.bringSubviewToFront(plusButton)
        //TODO fix button position
        plusButton.frame = CGRect(origin: CGPoint(x: 161, y: 591), size: CGSize(width: 54, height: 54))
        plusButton.setImage(UIImage(named: "plusButton"), for: .normal)
    }

    private func setupPlusButton() {
        plusButton.setImage(UIImage(named: "plus-icon"), for: .normal)
        plusButton.rx
                .tap
                .subscribe(onNext: {
                    self.prepareNavigationToAddSpend()
                })
                .disposed(by: disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
