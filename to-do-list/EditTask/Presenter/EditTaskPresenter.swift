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
            guard let self = self else { return nil }
            
            return self.task.owner
        }) { [weak self] in
            guard let self = self else { return }
            
            self.coordinator?.showListsChoise(for: self.task, completion: { [weak self] in
                let indexPath = IndexPath(row: 0, section: 0)
                
                self?.view?.reloadRows(at: [indexPath])
            })
        }
        
        let titleOption = EditTaskTextFieldOption(text: task.title, placeholder: "Title", handler: { [weak self] text in
            
            self?.changeTaskTitle(text)
        })
        
        let detailOption = EditTaskTextViewOption(text: task.details ?? "", placeholder: "Detail", handler: { [weak self] text in
            
            self?.changeTaskDetail(text)
        })
        
        let reminderOption = EditTaskReminderOption(reminder: task.reminder, placeholder: "Add reminder") { [weak self] in
            
            self?.showReminder()
        }
        
        let taskDescriptionSection = EditTaskSection(title: "Task Description", option: [
            .EditTaskListCell(model: listOption),
            .EditTaskTextFieldCell(model: titleOption),
            .EditTaskTextViewCell(model: detailOption),
            .EditTaskReminderCell(model: reminderOption)
        ])
        
        sections = [taskDescriptionSection]
    }
    
    // MARK: - Secions Handlers
    private func showReminder() {
        coordinator?.showReminder(completion: { [weak self] date in
            
            DataManager.shared.toChange(handler: {
                self?.task.reminder?.date = date
            }) { isChanged in
                if isChanged {
                    guard let self = self, let reminder = self.task.reminder else { return }
                    
                    self.view?.updateView()
                    
                    self.notificationManager.sendNotification(with: reminder)
                }
            }
        })
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
