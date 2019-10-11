//
// Created by Piotr Kupczyk on 2019-02-19.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AddSpendViewModel {

    struct UIInputs {
        let submitTriggered: Observable<Void>
        let titleTypingTriggered: Observable<String>
        let valueTypingTriggered: Observable<String>
    }

    let group: Group

    let bag = DisposeBag()

    private let users = BehaviorRelay<[User]>(value: [])

    let title = BehaviorRelay<String>(value: "")

    let currency = BehaviorRelay<String>(value: "")

    let didSpendCreated = BehaviorRelay<Spend?>(value: nil)

    lazy var usersObservable: Observable<[User]> = {
        return self.users.asObservable()
    }()

    var didSubmit: Observable<Void>!

    func createSpend(title: String, value: Double, payerId: String, concerns: [String]) {
        GroupService.addSpend(
                groupId: group.id,
                title: title,
                value: value,
                payerId: payerId,
                concerns: concerns
        ) { fetchSpend in
            guard let spend = fetchSpend else { return }
            print("Created spend [\(spend)]")
            self.didSpendCreated.accept(spend)
        }
    }

    init(inputs: UIInputs, group: Group) {
        self.group = group

        didSubmit = inputs.submitTriggered.map {
            self.createSpend(
                    title: self.title.value,
                    value: Double(self.currency.value) ?? 0.0,
                    payerId: self.users.value[0].id,
                    concerns: self.users.value.map { $0.id }
            )
            print("Submit triggered")
        }

        inputs.titleTypingTriggered
                .throttle(1, scheduler: MainScheduler.instance)
                .bind(to: title)
                .disposed(by: bag)

        inputs.valueTypingTriggered
                .throttle(1, scheduler: MainScheduler.instance)
                .bind(to: currency)
                .disposed(by: bag)
    }

    public func updateUsers(with newUsers: [User]) {
        self.users.accept(newUsers)
    }

    public func addUser(user: User) {
        if !users.value.contains(where: { $0.id == user.id }) {
            users.acceptAppending(user)
        }
    }

    public func removeUser(user: User) {
        print("Removing... \(user.name)")
        //proper filtration will be implemented later
        users.accept(users.value.filter {
            $0.id != user.id
        })
    }

    public func removeAllUsers() {
        print("RemovingAll...")
        //proper filtration will be implemented later
        users.accept([])
    }
}