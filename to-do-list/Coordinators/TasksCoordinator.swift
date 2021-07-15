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
}
