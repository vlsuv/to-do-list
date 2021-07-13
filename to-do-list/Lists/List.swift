//
//  List.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

class List {
    var title: String
    var order: Int
    
    init(title: String, order: Int) {
        self.title = title
        self.order = order
    }
}
