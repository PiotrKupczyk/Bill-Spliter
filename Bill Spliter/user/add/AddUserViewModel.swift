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

    private let initialUsersIds: [String]!

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

    init(_ inputs: UIInputs, usersIds: [String] = []) {
        self.initialUsersIds = usersIds
        didSubmit = inputs.submitTrigger
                .map {
            self.selectedUsers.value
        }

        inputs.typingTrigger
                .throttle(0.75, scheduler: MainScheduler.instance)
                .subscribe(onNext: { text in
                    if text.count >= 2 {
                        self.users.flatMap { users in
                                    return Observable.just(users.filter { (user: User) -> Bool in
                                        return user.name.contains(text)
                                    })
                                }.bind(to: self.filteredUsers)
                                .disposed(by: self.bag)
                    } else {
                        self.filteredUsers.accept(self.users.value)
                    }
                })
                .disposed(by: bag)

        inputs.selectUser.subscribe { user in
            self.selectedUsers.acceptAppending(user.element.unsafelyUnwrapped)
        }.disposed(by: bag)

        inputs.deSelectUser.subscribe { user in
            self.selectedUsers.accept(self.selectedUsers.value.filter {
                $0.id != user.element.unsafelyUnwrapped.id
            })
        }.disposed(by: bag)
    }

    public func fetchData() {
        if initialUsersIds.isEmpty {
            UserService.getUsers { users in
                print("Fetched users [\(users)]")
                self.users.accept(users)
                self.filteredUsers.accept(users)
            }
        }
        else {
            initialUsersIds.forEach {
                UserService.getUserById(userId: $0) { _user in
                    guard let user = _user else { return }
                    self.users.acceptAppending(user)
                    print("Fetched user [\(user)]")
                }
            }
        }

    }

    public func isSelected(user: User) -> Bool {
        return selectedUsers.value.contains {
            $0.id == user.id
        }
    }
}
