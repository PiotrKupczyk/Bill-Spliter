//
//  GroupBillsViewModel.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 14/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GroupSpendsViewModel {
    public let spends = BehaviorRelay<[Spend]>(value: [])
    private let group: Group

    init(group: Group) {
        self.group = group
    }

    func addSpend(spend: Spend) {
        self.spends.acceptAppending(spend)
    }

    public func fetchData() {
        print("Got group [\(group.id)] members [\(group.members)]")
        self.spends.accept(
                self.spends.value + group.members.flatMap { $0.spends }
        )
    }
}
