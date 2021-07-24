//
//  EditTaskPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 17.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RealmSwift

protocol EditTaskViewProtocol: class {
    func updateView()
    func reloadRows(at indexPaths: [IndexPath])
}

protocol EditTaskPresenterInputs {
    func viewDidDisappear()
    func didTapDeleteTask()
    func didTapDone()
}

protocol EditTaskPresenterOutputs {
    var sections: [EditTaskSection] { get set }
    var markOfDone: String { get }
}

protocol EditTaskPresenterType {
    var inputs: EditTaskPresenterInputs { get }
    var outputs: EditTaskPresenterOutputs { get }
}

class EditTaskPresenter: EditTaskPresenterType, EditTaskPresenterInputs, EditTaskPresenterOutputs {
    
    // MARK: - Properties
    var inputs: EditTaskPresenterInputs { return self }
    var outputs: EditTaskPresenterOutputs { return self }
    
    private weak var view: EditTaskViewProtocol?
    
    private var coordinator: EditTaskCoordinator?
    
    private let task: Task
    
    private var taskObserver: NotificationToken?
    
    var sections: [EditTaskSection] = []
    
    var taskTitle: String = ""
    var taskDetails: String = ""
    
    private var notificationManager: NotificationManagerType
    
    var markOfDone: String {
        return task.isDone ? "Mark uncompleted" : "Mark completed"
    }
    
    // MARK: - Init
    init(view: EditTaskViewProtocol, coordinator: EditTaskCoordinator, task: Task) {
        self.view = view
        self.coordinator = coordinator
        self.task = task
        self.notificationManager = NotificationManager()
        
        configureSections()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Configures
    private func configureSections() {
        let listOption = EditTaskListOption(parentList: { [weak self] in
            return self?.task.owner
        }) { [weak self] in
            self?.showListsChoise()
        }
        
        let titleOption = EditTaskTitleTextViewOption(text: task.title, placeholder: "Enter title") { [weak self] text in
            self?.changeTaskTitle(text)
        }
        
        let detailOption = EditTaskTextViewOption(text: task.details, placeholder: "Add details", icon: Image.listImage) { [weak self] text in
            self?.changeTaskDetail(text)
        }
        
        let reminderOption = EditTaskReminderOption(reminder: { [weak self] in self?.task.reminder }, placeholder: "Add date/time", icon: Image.calendarIcon, handler: { [weak self] in
            self?.showReminder()
        }) { [weak self] in
            self?.removeReminder()
        }
        
        let taskDescriptionSection = EditTaskSection(title: "Task Description", option: [
            .EditTaskListCell(model: listOption),
            .EditTaskTitleTextViewCell(model: titleOption),
            .EditTaskTextViewCell(model: detailOption),
            .EditTaskReminderCell(model: reminderOption)
        ])
        
        sections = [taskDescriptionSection]
    }
    
    // MARK: - Secions Handlers
    private func showListsChoise() {
        coordinator?.showListsChoise(for: self.task, completion: { [weak self] in
            let indexPath = IndexPath(row: 0, section: 0)
            
            self?.view?.reloadRows(at: [indexPath])
        })
    }
    
    private func showReminder() {
        coordinator?.showReminder(completion: { [weak self] reminderDate in
            guard let self = self else { return }
            
            if let oldReminder = self.task.reminder {
                DataManager.shared.deleteReminder(oldReminder, completion: nil)
            }
            
            let newReminder = Reminder(title: self.task.title, date: reminderDate)
            
            DataManager.shared.addReminder(newReminder, to: self.task) { isAdded in
                if isAdded {
                    self.view?.updateView()
                }
            }
        })
    }
    
    private func removeReminder() {
        guard let reminder = task.reminder else { return }
        
        DataManager.shared.deleteReminder(reminder) { [weak self] isDeleted in
            self?.view?.updateView()
        }
    }
    
    private func changeTaskTitle(_ text: String) {
        DataManager.shared.toChange(handler: { [weak self] in
            self?.task.title = text
            }, completion: nil)
    }
    
    private func changeTaskDetail(_ text: String) {
        DataManager.shared.toChange(handler: { [weak self] in
            self?.task.details = text
            }, completion: nil)
    }
    
    // MARK: - Inputs Handlers
    func viewDidDisappear() {
        coordinator?.viewDidDisappear()
    }
    
    func didTapDeleteTask() {
        DataManager.shared.deleteTask(task) { [weak self] isDeleted in
            if isDeleted {
                self?.coordinator?.didFinishEditTask()
            }
        }
    }
    
    func didTapDone() {
        DataManager.shared.toChange(handler: { [weak self] in
            self?.task.isDone.toggle()
        }) { isChanged in
            if isChanged {
                self.coordinator?.didFinishEditTask()
            }
        }
    }
}
