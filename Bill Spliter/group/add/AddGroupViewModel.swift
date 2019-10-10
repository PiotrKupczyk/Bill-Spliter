//
// Created by Piotr Kupczyk on 2019-02-19.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AddGroupViewModel {

    struct UIInputs {
        let submitTriggered: Observable<Void>
        let titleTypingTriggered: Observable<String>
        let currencyTypingTriggered: Observable<String>
    }

    let bag = DisposeBag()

    private let users = BehaviorRelay<[User]>(value: [])

    let title = BehaviorRelay<String>(value: "")

    let currency = BehaviorRelay<String>(value: "")

    let didGroupCreated = BehaviorRelay<Group?>(value: nil)

    lazy var usersObservable: Observable<[User]> = {
        return self.users.asObservable()
    }()

    var didSubmit: Observable<Void>!

    init(inputs: UIInputs) {
        didSubmit = inputs.submitTriggered.map {
            self.createGroup(
                    title: self.title.value,
                    usersIds: self.users.value.map { $0.id }
            )
        }

        inputs.titleTypingTriggered
                .throttle(1, scheduler: MainScheduler.instance)
                .bind(to: title)
                .disposed(by: bag)

        inputs.currencyTypingTriggered
                .throttle(1, scheduler: MainScheduler.instance)
                .bind(to: currency)
                .disposed(by: bag)
    }

    private func createGroup(title: String, usersIds: [String]) {
        GroupService.createGroup(name: title, usersIds: usersIds) { group in
            guard let createdGroup: Group = group else {
                print("Error fetching group /POST create group ");
                return
            }
            print("Created group [\(createdGroup)]")
            self.didGroupCreated.accept(createdGroup)
        }
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

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func acceptAppending(_ element: Element.Element) {
        accept(value + [element])
    }
}
