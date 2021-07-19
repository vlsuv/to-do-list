//
//  Reminder.swift
//  to-do-list
//
//  Created by vlsuv on 19.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RealmSwift

class Reminder: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date = Date()
    
    convenience init(title: String, date: Date) {
        self.init()
        self.title = title
        self.date = date
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
