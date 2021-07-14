//
//  NewListCoordinator.swift
//  to-do-list
//
//  Created by vlsuv on 14.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class NewListCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    var parentCoordinator: Coordinator?
    
    private let navigationController: UINavigationController
    
    private let assemblyBuilder: AssemblyModuleBuilderProtocol
    
    private var list: List?
    
    // MARK: - Init
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol = AssemblyModuleBuilder(), list: List?) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
        self.list = list
    }
    
    func start() {
        let newListController = assemblyBuilder.createNewListController(coordinator: self, with: list)
        
        navigationController.pushViewController(newListController, animated: true)
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Handlers
    func viewDidDisappear() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func didFinishAddNewList() {
        navigationController.popViewController(animated: true)
    }
}
