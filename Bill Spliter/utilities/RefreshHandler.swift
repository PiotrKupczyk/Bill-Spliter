//
// Created by Piotr Kupczyk on 11/11/2019.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class RefreshHandler: NSObject {
    let refresh = PublishSubject<Void>()
    let refreshControl = UIRefreshControl()
    init(view: UIScrollView) {
        super.init()
        view.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControlDidRefresh(_: )), for: .valueChanged)
    }
    // M@objc ARK: - Action
    @objc func refreshControlDidRefresh(_ control: UIRefreshControl) {
        refresh.onNext(())
    }
    func end() {
        refreshControl.endRefreshing()
    }
}
