//
// Created by Piotr Kupczyk on 2019-02-19.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift

class AddGroupViewModel {
    private let disposeBag = DisposeBag()
    let groupMembers = PublishSubject<[User]>()
    private var members = [User]()
//    let groupTitle = PublishSubject<String>()
//    let groupCurrency = PublishSubject<String>()


    public func createGroup(title: String, currency: String) -> Group {
        //here will we api service
        let newGroup = Group(title: title, imageName: "home-icon", groupBalance: 0)
        return newGroup
    }

    public func addUser(user: User) {
        members.append(user)
        groupMembers.onNext(members)
    }

    public func removeUser(user: User) {
        print("Removing...")
        members = members.filter { $0 === user }
//                .map { print($0) }
        groupMembers.onNext(members)
//        groupMembers.onNext([User]())
//        members = members.filter { $0 === user}
//        groupMembers.onNext(members)
    }


}