//
//  EditTaskSection.swift
//  to-do-list
//
//  Created by vlsuv on 18.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

struct EditTaskSection {
    var title: String
    var option: [EditTaskSectionOption]
}

enum EditTaskSectionOption {
    case EditTaskTextFieldCell(model: EditTaskTextFieldOption)
    case EditTaskTextViewCell(model: EditTaskTextViewOption)
    case EditTaskListCell(model: EditTaskListOption)
}

struct EditTaskTextFieldOption {
    var text: String
    var placeholder: String
    var handler: ((String) -> ())?
}

struct EditTaskTextViewOption {
    var text: String
    var placeholder: String
    var handler: ((String) -> ())?
}

struct EditTaskListOption {
    var parentList: (() -> (ListModel?))
    var handler: (() -> ())?
}
