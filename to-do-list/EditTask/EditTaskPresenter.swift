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
}

protocol EditTaskPresenterOutputs {
    
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
    
    // MARK: - Init
    init(view: EditTaskViewProtocol, coordinator: EditTaskCoordinator, task: Task) {
        self.view = view
        self.coordinator = coordinator
        self.task = task
    }
    
    deinit {
        print("deinit: \(self)")
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
}
