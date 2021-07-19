//
//  NewTaskCoordinator.swift
//  to-do-list
//
//  Created by vlsuv on 15.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class NewTaskCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    var parentCoordinator: Coordinator?
    
    private let navigationController: UINavigationController
    
    private let assemblyBuilder: AssemblyModuleBuilderProtocol
    
    private let list: ListModel
    
    // MARK: - Init
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol = AssemblyModuleBuilder(), list: ListModel) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
        self.list = list
    }
    
    func start() {
        let newTaskController = assemblyBuilder.createNewTaskController(coordinator: self, for: list)
        
        newTaskController.modalPresentationStyle = .custom
        newTaskController.transitioningDelegate = navigationController
        
        navigationController.present(newTaskController, animated: true, completion: nil)
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
    
    func didFinishAddNewTask() {
        navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func showReminder(completion: ((Date) -> ())?) {
        let reminderCoordinator = ReminderCoordinator(navigationController: navigationController)
        reminderCoordinator.parentCoordinator = self
        childCoordinators.append(reminderCoordinator)
        reminderCoordinator.start()
        
        reminderCoordinator.didSelectDate = completion
    }
}
