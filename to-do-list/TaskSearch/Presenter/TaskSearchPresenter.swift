//
//  TaskSearchPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 15.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RealmSwift

protocol TaskSearchViewProtocol: class {
    func updateView()
}

protocol TaskSearchPresenterInputs {
    func didTapCancel()
    func didChangeSearchText(_ query: String)
    func didTapDoneButton(at indexPath: IndexPath)
    func didSelectTask(at indexPath: IndexPath)
}

protocol TaskSearchPresenterOutputs {
    var searchTasks: Results<Task>? { get set }
}

protocol TaskSearchPresenterType {
    var inputs: TaskSearchPresenterInputs { get }
    var outputs: TaskSearchPresenterOutputs { get }
}

class TaskSearchPresenter: TaskSearchPresenterType, TaskSearchPresenterInputs, TaskSearchPresenterOutputs {
    
    // MARK: - Properties
    var inputs: TaskSearchPresenterInputs { return self }
    var outputs: TaskSearchPresenterOutputs { return self }
    
    private weak var view: TaskSearchViewProtocol?
    
    private var coordinator: TaskSearchCoordinator?
    
    // MARK: - Tasks Properties
    private var tasks: Results<Task>
    
    var searchTasks: Results<Task>?
    
    private var tasksObserver: NotificationToken?
    
    // MARK: - Init
    init(view: TaskSearchViewProtocol, coordinator: TaskSearchCoordinator) {
        self.view = view
        self.coordinator = coordinator
        
        tasks = DataManager.shared.getAllTasks()
        
        addTasksObserver()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Configures
    private func addTasksObserver() {
        tasksObserver = tasks.observe({ [weak self] changes in
            self?.view?.updateView()
        })
    }
    
    // MARK: - Inputs Handlers
    func didTapCancel() {
        coordinator?.didFinishTaskSearch()
    }
    
    func didChangeSearchText(_ query: String) {
        searchTasks = tasks.filter("title CONTAINS[cd] %@", "\(query.lowercased())")
        view?.updateView()
    }
    
    func didTapDoneButton(at indexPath: IndexPath) {
        guard let task = searchTasks?[indexPath.row] else { return }
        
        DataManager.shared.toChange(handler: {
            task.isDone.toggle()
        }) { isChanged in
            if isChanged {
                print("Task is changed")
            }
        }
    }
    
    func didSelectTask(at indexPath: IndexPath) {
        guard let task = searchTasks?[indexPath.row] else { return }
        
        coordinator?.showEditTask(for: task)
    }
}
