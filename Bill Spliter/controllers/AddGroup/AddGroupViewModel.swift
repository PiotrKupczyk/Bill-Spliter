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

    lazy var usersObservable: Observable<[User]> = {
        return self.users.asObservable()
    }()

    var didSubmit: Observable<Group>!

    init(inputs: UIInputs) {
        didSubmit = inputs.submitTriggered
                .map{
                    Group(title: self.title.value, imageName: "home-icon", groupBalance: 0)
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

    public func createGroup(title: String, currency: String) {
        //here will we api service
        let group = Group(title: title, imageName: "home-icon", groupBalance: 0)
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
