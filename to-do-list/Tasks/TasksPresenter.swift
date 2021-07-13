//
//  TasksPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol TasksViewProtocol: class {
    func updateView()
    func insertRows(at indexPaths: [IndexPath])
    func deleteRows(at indexPaths: [IndexPath])
}

protocol TasksPresenterInputs {
    func viewDidDisappear()
    func didSelectTask(at indexPath: IndexPath)
    func didTapDone(at indexPath: IndexPath)
}

protocol TasksPresenterOutputs {
    var taskSections: [TasksSection] { get set }
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
    
    var taskSections: [TasksSection] = []
    
    private var unfinishedTasks: [Task] = []
    private var finishedTasks: [Task] = []
    
    // MARK: - Init
    init(view: TasksViewProtocol, coordinator: TasksCoordinator) {
        self.view = view
        self.coordinator = coordinator
        
        getTasks()
        configureTasksSections()
    }
    
    func viewDidDisappear() {
        coordinator.viewDidDisappear()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Fetching
    private func getTasks() {
        unfinishedTasks = [Task(title: "bar"), Task(title: "bar"), Task(title: "bar"), Task(title: "bar")]
        finishedTasks = [Task(title: "baz"), Task(title: "baz")]
    }
    
    // MARK: - Handlers
    private func configureTasksSections() {
        let unfinishedTasksSection = TasksSection(title: "tasks", tasks: unfinishedTasks, isExpand: true)
        
        let finishedTasksSection = TasksSection(title: "finished tasks", tasks: finishedTasks, isExpand: false)
        
        taskSections = [unfinishedTasksSection, finishedTasksSection]
    }
    
    func didSelectTask(at indexPath: IndexPath) {
        if indexPath.row == 0 {
            taskSections[indexPath.section].isExpand.toggle()
            
            let section = taskSections[indexPath.section]
            
            if section.isExpand {
                var indexPathsToShow: [IndexPath] = []
                
                for i in 0..<section.tasks.count {
                    indexPathsToShow.append(IndexPath(row: i + 1, section: indexPath.section))
                }
                
                view?.insertRows(at: indexPathsToShow)
                
            } else {
                var indexPathsToDelete: [IndexPath] = []
                
                for i in 0..<section.tasks.count {
                    indexPathsToDelete.append(IndexPath(row: i + 1, section: indexPath.section))
                }
                
                view?.deleteRows(at: indexPathsToDelete)
            }
        }
    }
    
    func didTapDone(at indexPath: IndexPath) {
    }
}
