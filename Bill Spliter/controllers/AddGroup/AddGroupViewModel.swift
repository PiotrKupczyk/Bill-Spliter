//
// Created by Piotr Kupczyk on 2019-02-19.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AddGroupViewModel {
    private let users = BehaviorRelay<[User]>(value: [])
    private let newGroup = PublishSubject<Group>()

    lazy var usersObservable: Observable<[User]> = {
        return self.users.asObservable()
    }()

    let submitPressed = PublishSubject<Void>()

    let titleSet = PublishSubject<String>()

    let currencySet = PublishSubject<String>()

    init() {

    }

    public func createGroup(title: String, currency: String) {
        //here will we api service
        let group = Group(title: title, imageName: "home-icon", groupBalance: 0)
        newGroup.onNext(group)
    }

    public func updateUsers(with newUsers: [User]) {
        self.users.accept(newUsers)
    }

    public func addUser(user: User) {
        if !users.value.contains(where: { $0.id == user.id}) {
            users.acceptAppending(user)
        }
    }

    public func removeUser(user: User) {
        print("Removing... \(user.name)")
        //proper filtration will be implemented later
        users.accept(users.value.filter { $0.id != user.id })
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
