//
//  TasksSection.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RealmSwift

struct TasksSection {
    var title: String
    var tasks: Results<Task>
    var isExpand: Bool = true
    var canMove: Bool
    var canDone: Bool
}
