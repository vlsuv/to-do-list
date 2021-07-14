//
//  NewListSection.swift
//  to-do-list
//
//  Created by vlsuv on 14.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

struct NewListSection {
    var title: String
    var option: [NewListSectionOption]
}

enum NewListSectionOption {
    case textFieldCell(model: TextFieldCellOption)
}

struct TextFieldCellOption {
    var text: String
    var placeholder: String
    var handler: ((String) -> ())?
}
