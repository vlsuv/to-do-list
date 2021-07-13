//
//  Task.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

class Task {
    var title: String
    var isDone: Bool = false
    
    init(title: String) {
        self.title = title
    }
}
