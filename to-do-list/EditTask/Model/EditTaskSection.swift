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
    case EditTaskTitleTextViewCell(model: EditTaskTitleTextViewOption)
    case EditTaskTextViewCell(model: EditTaskTextViewOption)
    case EditTaskListCell(model: EditTaskListOption)
    case EditTaskReminderCell(model: EditTaskReminderOption)
}

struct EditTaskListOption {
    var parentList: (() -> (ListModel?))
    var handler: (() -> ())?
}

struct EditTaskTitleTextViewOption {
    var text: (() -> (String))?
    var placeholder: String
    var handler: ((String) -> ())?
}

struct EditTaskTextViewOption {
    var text: (() -> (String?))?
    var placeholder: String?
    var icon: UIImage?
    var handler: ((String) -> ())?
}

struct EditTaskReminderOption {
    var reminder: (() -> (Reminder?))
    var placeholder: String
    var icon: UIImage?
    var handler: (() -> ())?
    var cancelHandler: (() -> ())?
}
