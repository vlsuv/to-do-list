//
//  EditTaskPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 17.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol EditTaskViewProtocol: class {
    
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
    
    var sections: [EditTaskSection] = []
    
    var taskTitle: String = ""
    var taskDetails: String = ""
    
    // MARK: - Init
    init(view: EditTaskViewProtocol, coordinator: EditTaskCoordinator, task: Task) {
        self.view = view
        self.coordinator = coordinator
        self.task = task
        
        configureSections()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Configures
    private func configureSections() {
        let listOption = EditTaskListOption(parentList: task.owner!) { [weak self] list in
            guard let self = self else { return }
            
            self.changeParentList(from: self.task.owner!, to: list)
        }
        let titleOption = EditTaskTextFieldOption(text: task.title, placeholder: "Title", handler: { [weak self] text in
            
            DataManager.shared.toChange(handler: {
                self?.task.title = text
            }, completion: nil)
            
        })
        let detailOption = EditTaskTextViewOption(text: task.details ?? "", placeholder: "Detail", handler: { [weak self] text in
            
            DataManager.shared.toChange(handler: {
                self?.task.details = text
            }, completion: nil)
            
        })
        
        let descriptionSection = EditTaskSection(title: "Task Description", option: [.EditTaskListCell(model: listOption), .EditTaskTextFieldCell(model: titleOption), .EditTaskTextViewCell(model: detailOption)])
        
        sections = [descriptionSection]
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
    
    // MARK: - Handlers
    private func changeParentList(from ownerList: ListModel, to list: ListModel) {
        guard let taskIndex = ownerList.tasks.firstIndex(of: task) else { return }
        
        DataManager.shared.toChange(handler: {
            ownerList.tasks.remove(at: taskIndex)
            
            task.owner = list
            
            list.tasks.append(task)
        }) { isChanged in
            if isChanged {
                print("task owner is changed")
            }
        }
    }
}
