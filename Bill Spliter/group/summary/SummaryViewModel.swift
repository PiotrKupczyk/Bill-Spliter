//
// Created by Piotr Kupczyk on 28/10/2019.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct Balance {
    let debtorImage: String
    let userName: String
    let debtor: String
    let value: Double
}

class SummaryViewModel {

    let dataSource = BehaviorRelay<[Balance]>(value: [])
    private let users: [User]!

    init(users: [User]) {
        self.users = users
    }

    func calculateBalance(members: [Member]) {
        typealias Debtor = String
        typealias UserId = String
        var balance = [UserId: [Debtor: Double]]()
        members.forEach { member in
            member.spends.forEach { spend in
//                balance.apply(key: member.userId, value: spend.value)
                let eachUserPays = spend.value / Double(spend.concerns.count)
                spend.concerns.forEach { debtor in
                    if member.userId != debtor {
                        balance.apply(userId: member.userId, debtor: debtor, value: -eachUserPays)
                    }
                }
            }
        }

        dataSource.accept(
                balance.flatMap { (userId: String, debts: [String: Double]) -> [Balance] in
                    debts.map { debtorId, value in
                        let userWhoPaid = users.first { $0.id == userId }!
                        let debtor = users.first { $0.id == debtorId }!
                        return Balance(debtorImage: debtor.imageURL, userName: userWhoPaid.name, debtor: debtor.name, value: value)
                    }
                }
        )
    }
}

extension Dictionary where Key == String, Value == [String: Double] {
    mutating func apply(userId: String, debtor: String, value: Double) {
        var userBalance = self[userId] ?? [:]
        let debtorValue = userBalance[debtor] ?? 0.0
        userBalance.updateValue(debtorValue + value, forKey: debtor)
        self.updateValue(userBalance, forKey: userId)
    }
}
