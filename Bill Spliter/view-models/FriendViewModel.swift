//
//  FriendsViewModel.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 12/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FriendViewModel {

    private let users = BehaviorRelay<[User]>(value: [])

    //MARK: - Input
    public let submit: AnyObserver<Void>

    public let select: AnyObserver<User>

    public let cancel: AnyObserver<Void>

    public let deSelect: AnyObserver<User>

    public let anyUserSelected: AnyObserver<Bool>

    //MARK: - Output

    public let didSubmit: Observable<Void>

    public let didCancel: Observable<Void>

    public let didSelect: Observable<User>

    public let didDeSelect: Observable<User>

    public let isAnyUserSelected: Observable<Bool>

    lazy var usersObservable: Observable<[User]> = {
        return self.users.asObservable()
    }()

    init() {
        let _submit = PublishSubject<Void>()
        submit = _submit.asObserver()
        didSubmit = _submit.asObservable()

        let _cancel = PublishSubject<Void>()
        cancel = _cancel.asObserver()
        didCancel = _cancel.asObservable()

        let _select = PublishSubject<User>()
        select = _select.asObserver()
        didSelect = _select.asObservable()

        let _deSelect = PublishSubject<User>()
        deSelect = _deSelect.asObserver()
        didDeSelect = _deSelect.asObservable()

        let _anyUserSelected = PublishSubject<Bool>()
        anyUserSelected = _anyUserSelected.asObserver()
        isAnyUserSelected = _anyUserSelected.asObservable()

    }
    
    public func fetchData() {
        let friend = User(id: "someID", imageURL: "https://ui-avatars.com/api/?name=Weronika+Relich&size=75&color=FFFFF&background=007AFF", name: "Weronika Relich")
        let friend2 = User(id: "someI2", imageURL: "https://ui-avatars.com/api/?name=Pawel+Wichary&size=75&color=FFFFF&background=007AFF", name: "Pawel Wichary")
        let friend3 = User(id: "someI3", imageURL: "https://ui-avatars.com/api/?name=Pawel+Wichary&size=75&color=FFFFF&background=007AFF", name: "Pawel Wichary")
        users.acceptAppending(friend)
        users.acceptAppending(friend2)
        users.acceptAppending(friend3)
    }
}
