//
// Created by Piotr Kupczyk on 2019-02-19.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift

class AddGroupViewModel {
    private let disposeBag = DisposeBag()
    let groupMembers = PublishSubject<[User]>()
//    let groupTitle = PublishSubject<String>()
//    let groupCurrency = PublishSubject<String>()


    public func createGroup(title: String, currency: String) -> Group {
        //here will we api service
        let newGroup = Group(title: title, imageName: "home-icon", groupBalance: 0)
        return newGroup
    }

    public func addUsers(users: [User]) {
        groupMembers.onNext(users)
    }
}