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

class FriendViewModel {
    //TODO
    let dataSource = PublishSubject<[User]>()
    let selectedUsers = PublishSubject<[User]>()
    private var selectedUsersArray = [User]()
    init() {}
    
    public func fetchData() {
        let friend = User(imageURL: "https://ui-avatars.com/api/?name=Weronika+Relich&size=75&color=FFFFF&background=007AFF", name: "Weronika Relich")
        var friends = [User]()
        friends.append(friend)
        friends.append(friend)
        friends.append(friend)
        friends.append(friend)
        friends.append(friend)
        friends.append(friend)
        friends.append(friend)
        friends.append(friend)
        friends.append(friend)
        friends.append(friend)
        friends.append(friend)
        friends.append(friend)
        dataSource.onNext(friends)
    }

    func selectUser(user: User) {
        selectedUsersArray.append(user)
        selectedUsers.onNext(selectedUsersArray)
    }
}
