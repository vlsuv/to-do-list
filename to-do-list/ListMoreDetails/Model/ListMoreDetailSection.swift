//
//  ListMoreDetailSection.swift
//  to-do-list
//
//  Created by vlsuv on 27.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

struct ListMoreDetailSection {
    var title: String
    var options: [ListMoreDetailOption]
}

enum ListMoreDetailOption {
    case ListMoreDetailStaticCell(model: ListMoreDetailStaticCellOption)
}

struct ListMoreDetailStaticCellOption {
    var title: String
    var handler: (() -> ())?
}
