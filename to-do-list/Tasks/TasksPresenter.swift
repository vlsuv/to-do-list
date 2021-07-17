//
//  TasksPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RealmSwift

protocol TasksViewProtocol: class {
    func updateView()
    func insertRows(at indexPaths: [IndexPath])
    func deleteRows(at indexPaths: [IndexPath])
}

protocol TasksPresenterInputs {
    func viewDidDisappear()
    func didSelectTask(at indexPath: IndexPath)
    func didTapDone(at indexPath: IndexPath)
    func didTapNewTask()
    func didMoveTask(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath)
}

protocol TasksPresenterOutputs {
    var taskSections: [TasksSection] { get set }
}

protocol TasksPresenterType {
    var inputs: TasksPresenterInputs { get }
    var outputs: TasksPresenterOutputs { get }
}

class TasksPresenter: TasksPresenterType, TasksPresenterInputs, TasksPresenterOutputs {
    
    // MARK: - Presenter Properties
    var inputs: TasksPresenterInputs { return self }
    var outputs: TasksPresenterOutputs { return self }
    
    private var coordinator: TasksCoordinator
    
    private weak var view: TasksViewProtocol?
    
    // MARK: - Tasks Properties
    var taskSections: [TasksSection] = []
    
    private let list: ListModel
    
    private var unfinishedTasks: Results<Task> {
        return list.tasks.filter("isDone == false").sorted(byKeyPath: "order", ascending: true)
    }
    private var finishedTasks: Results<Task> {
        return list.tasks.filter("isDone == true")
    }
    
    private var tasksObserver: NotificationToken?
    
    // MARK: - Init
    init(view: TasksViewProtocol, coordinator: TasksCoordinator, list: ListModel) {
        self.view = view
        self.coordinator = coordinator
        self.list = list
        
        addTasksObserver()
        configureTasksSections()
    }
    
    func viewDidDisappear() {
        coordinator.viewDidDisappear()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Tasks Configures
    private func addTasksObserver() {
        tasksObserver = list.tasks.observe({ [weak self] changes in
            self?.view?.updateView()
        })
    }
    
    private func configureTasksSections() {
        let unfinishedTasksSection = TasksSection(title: "tasks", tasks: unfinishedTasks, isExpand: true, canMove: true, canDone: true)
        
        let finishedTasksSection = TasksSection(title: "finished tasks", tasks: finishedTasks, isExpand: false, canMove: false, canDone: false)
        
        taskSections = [unfinishedTasksSection, finishedTasksSection]
    }
    
    // MARK: - Inputs Handlers
    func didSelectTask(at indexPath: IndexPath) {
        let section = taskSections[indexPath.section]
        
        if indexPath.row == 0 {
            taskSections[indexPath.section].isExpand.toggle()
            
            if !section.isExpand {
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
        } else {
            let task = section.tasks[indexPath.row - 1]

            coordinator.showEditTask(for: task)
        }
    }
    
    func didTapDone(at indexPath: IndexPath) {
        let task = taskSections[indexPath.section].tasks[indexPath.row - 1]
        
        DataManager.shared.toChange(handler: {
            task.isDone.toggle()
        }, completion: nil)
    }
    
    func didTapNewTask() {
        coordinator.showNewTask(for: list)
    }
    
    func didMoveTask(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        let sourceSection = taskSections[sourceIndexPath.section]
        let destinationSection = taskSections[destinationIndexPath.section]
        
        guard sourceSection.canMove, destinationSection.canMove, sourceIndexPath.row > 0, destinationIndexPath.row > 0 else {
            return
        }
        
        let sourceTask = sourceSection.tasks[sourceIndexPath.row - 1]
        let destinationTask = destinationSection.tasks[destinationIndexPath.row - 1]
        
        DataManager.shared.toChange(handler: {
            swap(&sourceTask.order, &destinationTask.order)
        }, completion: nil)
    }
}
