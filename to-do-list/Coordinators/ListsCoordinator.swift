//
//  ListsCoordinator.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RealmSwift

class ListsCoordinator: Coordinator {
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    
    var parentCoordinator: Coordinator?
    
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    private let assemblyBuilder: AssemblyModuleBuilderProtocol
    
    // MARK: - Init
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol = AssemblyModuleBuilder()) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func start() {
        let listController = assemblyBuilder.createListsController(coordinator: self)
        
        navigationController.viewControllers = [listController]
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { childCoordinator === $0 }) else { return }
        
        childCoordinators.remove(at: index)
    }
    
    // MARK: - Handlers
    func showTasks(for list: ListModel) {
        let tasksCoordinator = TasksCoordinator(navigationController: navigationController, list: list)
        childCoordinators.append(tasksCoordinator)
        tasksCoordinator.parentCoordinator = self
        tasksCoordinator.start()
    }
    
    func showNewList(with list: ListModel?) {
        let newListCoordinator = NewListCoordinator(navigationController: navigationController, list: list)
        childCoordinators.append(newListCoordinator)
        newListCoordinator.parentCoordinator = self
        newListCoordinator.start()
    }
    
    func showTaskSearch() {
        let taskSearchCoordinator = TaskSearchCoordinator(navigationController: navigationController)
        childCoordinators.append(taskSearchCoordinator)
        taskSearchCoordinator.parentCoordinator = self
        taskSearchCoordinator.start()
    }
}
