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

class AddUserViewModelViewModel {
    let bag = DisposeBag()

    private let users = BehaviorRelay<[User]>(value: [])

    private let filteredUsers = BehaviorRelay<[User]>(value: [])

    let selectedUsers = BehaviorRelay<[User]>(value: [])

    struct UIInputs {
        let selectUser: Observable<User>
        let deSelectUser: Observable<User>
        let submitTrigger: Observable<Void>
        let typingTrigger: Observable<String>
    }

    //MARK: - Output

    var didSubmit: Observable<[User]>!

    lazy var isSubmitEnabled: Observable<Bool> = {
        return self.selectedUsers.asObservable()
                                .map { users -> Bool in
                                    return true && !users.isEmpty
                                }
    }()

    lazy var usersObservable: Observable<[User]> = {
        return self.filteredUsers.asObservable()
    }()

    init(_ inputs: UIInputs) {
        didSubmit = inputs.submitTrigger
                            .map { self.selectedUsers.value }

        inputs.typingTrigger
                .throttle(0.75, scheduler: MainScheduler.instance)
                .subscribe(onNext: { text in
                    self.users.flatMap { users in
                        return Observable.just(users.filter { (user: User) -> Bool in
                                return user.name.contains(text)
                            })
                    }.bind(to: self.filteredUsers)
                    .disposed(by: self.bag)
                })
                .disposed(by: bag)

        inputs.selectUser.subscribe { user in
            self.selectedUsers.acceptAppending(user.element.unsafelyUnwrapped)
        }.disposed(by: bag)

        inputs.deSelectUser.subscribe { user in
            self.selectedUsers.accept(self.selectedUsers.value.filter {$0.id != user.element.unsafelyUnwrapped.id})
        }.disposed(by: bag)
    }

    public func fetchData() {
        let friend = User(id: "someID", imageURL: "https://ui-avatars.com/api/?name=Weronika+Relich&size=75&color=FFFFF&background=007AFF", name: "Weronika Relich")
        let friend2 = User(id: "someI2", imageURL: "https://ui-avatars.com/api/?name=Pawel+Wichary&size=75&color=FFFFF&background=007AFF", name: "Pawel Wichary")
        let friend3 = User(id: "someI3", imageURL: "https://ui-avatars.com/api/?name=Pawel+Wichary&size=75&color=FFFFF&background=007AFF", name: "Pawel Wichary")
        users.acceptAppending(friend)
        users.acceptAppending(friend2)
        users.acceptAppending(friend3)
    }

    public func isSelected(user: User) -> Bool {
        return selectedUsers.value.contains { $0.id == user.id}
    }
}
