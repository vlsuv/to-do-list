//
//  EditTaskCoordinator.swift
//  to-do-list
//
//  Created by vlsuv on 17.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class EditTaskCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set )var childCoordinators: [Coordinator] = [Coordinator]()
    
    var parentCoordinator: Coordinator?
    
    private let navigationController: UINavigationController
    
    private let assemblyBuilder: AssemblyModuleBuilderProtocol
    
    private let task: Task
    
    // MARK: - Init
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol = AssemblyModuleBuilder(), task: Task) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
        self.task = task
    }
    
    func start() {
        let editTaskController = assemblyBuilder.createEditTaskController(coordinator: self, for: task)
        
        navigationController.pushViewController(editTaskController, animated: true)
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
    
    func didFinishEditTask() {
        navigationController.popViewController(animated: true)
    }
    
    func showListsChoise(for task: Task, completion: (() -> ())?) {
        let listsChoiseCoordinator = ListsChoiseCoordinator(navigationController: navigationController, task: task)
        listsChoiseCoordinator.parentCoordinator = self
        listsChoiseCoordinator.didChangeList = completion
        childCoordinators.append(listsChoiseCoordinator)
        listsChoiseCoordinator.start()
    }
}
