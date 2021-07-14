//
//  List.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RealmSwift

//class List {
//    var title: String
//    var order: Int
//
//    init(title: String, order: Int) {
//        self.title = title
//        self.order = order
//    }
//}

class List: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var order: Int = 0
    
    convenience init(title: String, order: Int) {
        self.init()
        self.title = title
        self.order = order
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
