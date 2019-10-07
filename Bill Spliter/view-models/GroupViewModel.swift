//
//  GroupViewModel.swift
//  Bill Spliter
//
//  Created by Piotr Kupczyk on 10/02/2019.
//  Copyright © 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON

class GroupViewModel {
    public let dataSource = BehaviorSubject<[Group]>(value: [Group]())
    private var groups = [Group]()

    init() {
    }

    public func fetchData() {
        GroupService.getGroups { groups in
            self.dataSource.onNext(groups)
        }
    }

    public func addGroup(group: Group) {
        groups.append(group)
        dataSource.onNext(groups)
    }

    private func calculateBalance() -> Double {
        return 0.0
    }
}

extension SwiftyJSON.JSON {
    func decodeTo<T: Codable>(_ resultType: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(resultType, from: self.rawData())
        } catch {
            print("Can't decode json from \(self)")
            print(error.localizedDescription)
            return nil
        }
    }
}