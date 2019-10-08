//
//  GroupBillsViewModel.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 14/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift

class GroupBillsViewModel {
    public let dataSource = PublishSubject<[Spend]>()
    private let group: Group

    init(group: Group) {
        self.group = group
    }

    public func fetchData() {
//        let bill = Bill(imageURL: "https://ui-avatars.com/api/?name=Weronika+Relich&size=64&color=FFFFF&background=007AFF", tittle: "Pizza i cola", createdDate: 123142, name: "Werka", price: 36.12)
        let bills = group.members?
                .flatMap { member in
                    member.spends
                } ?? []
        dataSource.onNext(bills)
    }
}
