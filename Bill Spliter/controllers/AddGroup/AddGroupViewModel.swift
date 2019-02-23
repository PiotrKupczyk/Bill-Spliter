//
// Created by Piotr Kupczyk on 2019-02-19.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AddGroupViewModel {
    private let groupMembers = BehaviorRelay<[User]>(value: [])
    private let newGroup = PublishSubject<Group>()

    lazy var usersObservable: Observable<[User]> = {
        return self.groupMembers.asObservable()
    }()

    lazy var groupObservable: Observable<Group> = {
        return self.newGroup.asObservable()
    }()

    init() {
    }

    public func createGroup(title: String, currency: String) {
        //here will we api service
        let group = Group(title: title, imageName: "home-icon", groupBalance: 0)
        newGroup.onNext(group)
    }

    public func addUser(user: User) {
        if !groupMembers.value.contains(where: { $0.id == user.id}) {
            groupMembers.acceptAppending(user)
        }
    }

    public func removeUser(user: User) {
        print("Removing...")
        //proper filtration will be implemented later
        groupMembers.accept(groupMembers.value.filter { $0.id != user.id })
    }

    public func removeAllUsers() {
        print("RemovingAll...")
        //proper filtration will be implemented later
        groupMembers.accept([])
    }
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func acceptAppending(_ element: Element.Element) {
        accept(value + [element])
    }
}
