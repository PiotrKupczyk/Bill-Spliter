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
    private let resusedIdentifier = "cellId"
    let viewModel = GroupBillsViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
        bindCollectionView()
        viewModel.fetchData()
        // Do any additional setup after loading the view.
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    func setupViews() {
        collectionView.register(GroupBillsCollectionViewCell.self, forCellWithReuseIdentifier: resusedIdentifier)
        collectionView.backgroundColor = .white
        view.backgroundColor = .white
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }

    private func setupLayouts() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.snp.topMargin)
            maker.trailing.equalTo(view.snp.trailing)
            maker.leading.equalTo(view.snp.leading)
            maker.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func bindCollectionView() {
        viewModel.dataSource.bind(to: collectionView.rx.items(cellIdentifier: resusedIdentifier)) {
            (_, bill: Bill, cell: GroupBillsCollectionViewCell) in
            cell.billModel = bill
        }.disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 80)
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
