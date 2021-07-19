//
//  Task.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var details: String?
    @objc dynamic var isDone: Bool = false
    @objc dynamic var owner: ListModel?
    @objc dynamic var order: Int = 0
    @objc dynamic var reminder: Reminder?
    
    convenience init(title: String, details: String?, owner: ListModel? = nil, order: Int, reminder: Reminder? = nil) {
        self.init()
        self.title = title
        self.details = details
        self.owner = owner
        self.order = order
        self.reminder = reminder
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

