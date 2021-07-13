//
//  TasksPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol TasksViewProtocol: class {
    
}

protocol TasksPresenterInputs {
    func viewDidDisappear()
}

protocol TasksPresenterOutputs {
    
}

protocol TasksPresenterType {
    var inputs: TasksPresenterInputs { get }
    var outputs: TasksPresenterOutputs { get }
}

class TasksPresenter: TasksPresenterType, TasksPresenterInputs, TasksPresenterOutputs {
    
    // MARK: - Properties
    var inputs: TasksPresenterInputs { return self }
    var outputs: TasksPresenterOutputs { return self }
    
    private var coordinator: TasksCoordinator
    
    private weak var view: TasksViewProtocol?
    
    var unfinishedTasks: [Task] = [Task]()
    
    // MARK: - Init
    init(view: TasksViewProtocol, coordinator: TasksCoordinator) {
        self.view = view
        self.coordinator = coordinator
    }
    
    func viewDidDisappear() {
        coordinator.viewDidDisappear()
    }
    
    deinit {
        print("deinit: \(self)")
    }
}
