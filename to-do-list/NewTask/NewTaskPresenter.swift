//
//  NewTaskPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 15.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol NewTaskViewProtocol: class {
    func updateReminderLabel(with stringDate: String?)
}

protocol NewTaskPresenterInputs {
    func viewDidDisappear()
    func didChangeTitleText(_ text: String)
    func didChangeDetailText(_ text: String)
    func didTapSave()
    func didTapAddReminder()
    func didTapReminderButton()
}

protocol NewTaskPresenterOutputs {
    
}

protocol NewTaskPresenterType {
    var inputs: NewTaskPresenterInputs { get }
    var outputs: NewTaskPresenterOutputs { get }
}

class NewTaskPresenter: NewTaskPresenterType, NewTaskPresenterInputs, NewTaskPresenterOutputs {
    
    // MARK: - Properties
    var inputs: NewTaskPresenterInputs { return self }
    var outputs: NewTaskPresenterOutputs { return self }
    
    private weak var view: NewTaskViewProtocol?
    
    private var coordinator: NewTaskCoordinator
    
    private var notificationManager: NotificationManagerType
    
    private let list: ListModel
    
    var taskTitle: String = ""
    var taskDetail: String = ""
    var reminderDate: Date?
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    // MARK: - Init
    init(view: NewTaskViewProtocol, coordinator: NewTaskCoordinator, list: ListModel) {
        self.view = view
        self.coordinator = coordinator
        self.list = list
        
        self.notificationManager = NotificationManager()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Inputs Handlers
    func viewDidDisappear() {
        coordinator.viewDidDisappear()
    }
    
    func didChangeTitleText(_ text: String) {
        taskTitle = text
    }
    
    func didChangeDetailText(_ text: String) {
        taskDetail = text
    }
    
    func didTapSave() {
        guard !taskTitle.isEmpty else { return }
        
        let unfinishedTasks = list.tasks.filter("isDone == false").sorted(byKeyPath: "order", ascending: true)
        
        var taskReminder: Reminder? = nil
        
        if let reminderDate = reminderDate {
            taskReminder = Reminder(title: taskTitle, date: reminderDate)
        }
        
        DataManager.shared.toChange(handler: {
            
            let newTask: Task
            
            if let lastOrder = unfinishedTasks.last?.order {
                newTask = Task(title: taskTitle,
                               details: taskDetail,
                               owner: list,
                               order: lastOrder + 1,
                               reminder: taskReminder)
            } else {
                newTask = Task(title: taskTitle,
                               details: taskDetail,
                               owner: list,
                               order: 1,
                               reminder: taskReminder)
            }
            
            if let reminder = newTask.reminder {
                notificationManager.sendNotification(with: reminder)
            }
            
            list.tasks.append(newTask)
            
        }, completion: { [weak self] isAdded in
            if isAdded {
                self?.coordinator.didFinishAddNewTask()
            }
        })
    }
    
    func didTapAddReminder() {
        coordinator.showReminder { [weak self] date in
            self?.reminderDate = date
            
            guard let stringDate = self?.dateFormatter.string(from: date) else { return }
            
            self?.view?.updateReminderLabel(with: stringDate)
        }
    }
    
    func didTapReminderButton() {
        reminderDate = nil
        
        view?.updateReminderLabel(with: nil)
    }
}
