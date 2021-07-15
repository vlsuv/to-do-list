//
//  TaskSearchCoordinator.swift
//  to-do-list
//
//  Created by vlsuv on 15.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class TaskSearchCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    var parentCoordinator: Coordinator?
    
    private let navigationController: UINavigationController
    
    private let assemblyBuilder: AssemblyModuleBuilderProtocol
    
    private var modalNavigationController: UINavigationController?
    
    // MARK: - Init
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol = AssemblyModuleBuilder()) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func start() {
        let taskSearchController = assemblyBuilder.createTaskSearchController(coordinator: self)
        
        modalNavigationController = UINavigationController()
        modalNavigationController?.viewControllers = [taskSearchController]
        modalNavigationController?.modalPresentationStyle = .fullScreen
        
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: false, completion: nil)
        }
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Handlers
    func didFinishTaskSearch() {
        navigationController.presentedViewController?.dismiss(animated: false, completion: nil)
        parentCoordinator?.childDidFinish(self)
    }
}
