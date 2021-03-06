//
//  TasksCoordinator.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class TasksCoordinator: Coordinator {
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    
    var parentCoordinator: Coordinator?
    
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    private let assemblyBuilder: AssemblyModuleBuilderProtocol
    
    private let list: ListModel
    
    // MARK: - Init
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol = AssemblyModuleBuilder(), list: ListModel) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
        self.list = list
    }
    
    func start() {
        let tasksController = assemblyBuilder.createTasksController(coordinator: self, for: list)
        navigationController.pushViewController(tasksController, animated: true)
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Handlers
    func viewDidDisappear() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { childCoordinator === $0 }) else { return }
        
        childCoordinators.remove(at: index)
    }
    
    func toPopViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func showNewTask(for list: ListModel) {
       let newTaskCoordinator = NewTaskCoordinator(navigationController: navigationController, list: list)
        childCoordinators.append(newTaskCoordinator)
        newTaskCoordinator.parentCoordinator = self
        newTaskCoordinator.start()
    }
    
    func showEditTask(for task: Task) {
        let editTaskCoordinator = EditTaskCoordinator(navigationController: navigationController, task: task)
        childCoordinators.append(editTaskCoordinator)
        editTaskCoordinator.parentCoordinator = self
        editTaskCoordinator.start()
    }
    
    func showListMoreDetail(completion: ((ListMoreDetailCompletionAction) -> ())?) {
        let listMoreDetailCoordinator = ListMoreDetailCoordinator(navigationController: navigationController, completion: completion)
        childCoordinators.append(listMoreDetailCoordinator)
        listMoreDetailCoordinator.parentCoordinator = self
        listMoreDetailCoordinator.start()
    }
    
    func showNewList(with list: ListModel?) {
        let newListCoordinator = NewListCoordinator(navigationController: navigationController, list: list)
        childCoordinators.append(newListCoordinator)
        newListCoordinator.parentCoordinator = self
        newListCoordinator.start()
    }
}
