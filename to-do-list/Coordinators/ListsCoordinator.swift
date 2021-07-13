//
//  ListsCoordinator.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class ListsCoordinator: Coordinator {
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    
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
}
