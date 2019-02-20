//
// Created by Piotr Kupczyk on 2019-02-19.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift

class AddGroupViewModel {
    private let disposeBag = DisposeBag()
    let groupMembers = PublishSubject<[User]>()
    let group = PublishSubject<Group>()
    private var members = [User]()

    public func createGroup(title: String, currency: String) {
        //here will we api service
        let newGroup = Group(title: title, imageName: "home-icon", groupBalance: 0)
        group.onNext(newGroup)
    }

    public func addUser(user: User) {
        members.append(user)
        groupMembers.onNext(members)
    }

    public func removeUser(user: User) {
        print("Removing...")
        //proper filtration will be implemented later
        members = members.filter { $0 === user }
        groupMembers.onNext(members)

    }
}
