//
//  GroupViewModel.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 10/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GroupViewModel {

    struct UIInputs {
        let groupSelected: Observable<Group>
    }

    public let groups = BehaviorRelay<[Group]>(value: [])
    public var navigateToGroupBillsTriggered: Observable<GroupBillsViewController>!

    init(inputs: UIInputs) {
        navigateToGroupBillsTriggered = inputs.groupSelected
                                                .map { group -> GroupBillsViewController in
                                                let vc = GroupBillsViewController()
                                                vc.viewModel = vc.view
                                        }
    }
    
    public func fetchData() {
        let groupOne = Group(title: "Amazing party", imageName: "home-icon", groupBalance: 123.98)
        let groupTwo = Group(title: "Home groceries", imageName: "home-icon", groupBalance: 12.36)
        groups.append(groupOne)
        groups.append(groupTwo)

        groups.onNext(groups)
    }

    public func addGroup(group: Group) {
        groups.acceptAppending(group)
//        groups.append(group)
//        groups.onNext(groups)
    }
}
