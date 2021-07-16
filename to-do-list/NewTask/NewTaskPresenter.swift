//
//  NewTaskPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 15.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol NewTaskViewProtocol: class {
    
}

protocol NewTaskPresenterInputs {
    func viewDidDisappear()
    func didChangeTitleText(_ text: String)
    func didChangeDetailText(_ text: String)
    func didTapSave()
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
    
    private let list: ListModel
    
    var taskTitle: String = ""
    
    var taskDetail: String = ""
    
    // MARK: - Init
    init(view: NewTaskViewProtocol, coordinator: NewTaskCoordinator, list: ListModel) {
        self.view = view
        self.coordinator = coordinator
        self.list = list
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
        
        DataManager.shared.toChange(handler: { [weak self] in
            
            if let lastOrder = unfinishedTasks.last?.order {
                self?.list.tasks.append(Task(title: taskTitle, details: taskDetail, owner: list, order: lastOrder + 1))
            } else {
                list.tasks.append(Task(title: taskTitle, details: taskDetail, owner: list, order: 1))
            }
            
            }, completion: { [weak self] isAdded in
                if isAdded {
                    self?.coordinator.didFinishAddNewTask()
                }
        })
    }
}
