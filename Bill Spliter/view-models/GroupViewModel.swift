//
//  GroupViewModel.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 10/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift

class GroupViewModel {
     // temp
    public let dataSource = BehaviorSubject<[Group]>(value: [Group]())
    
    init() {}
    
    public func fetchData() {
        let groupOne = Group(title: "Amazing party", imageName: "home-icon", groupBalance: 123.98)
        let groupTwo = Group(title: "Home groceries", imageName: "home-icon", groupBalance: 12.36)
        var groups = [Group]()
        groups.append(groupOne)
        groups.append(groupTwo)
        dataSource.onNext(groups)
    }
}

class BaseViewModel<T> {
    let disposeBag = DisposeBag()
    public let dataSource = PublishSubject<[T]>()
    
    init() {
        
    }
    
    func bind() {
    }
}
