//
//  List.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class ListModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var order: Int = 0
    let tasks = List<Task>()
    
    convenience init(title: String, order: Int) {
        self.init()
        self.title = title
        self.order = order
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
