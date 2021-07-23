//
//  ListsChoiseCoordinator.swift
//  to-do-list
//
//  Created by vlsuv on 19.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class ListsChoiseCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    private let navigationController: UINavigationController
    
    private let assemblyBuilder: AssemblyModuleBuilderProtocol
    
    private let task: Task
    
    var didChangeList: (() -> ())?
    
    // MARK: - Init
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol = AssemblyModuleBuilder(), task: Task) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
        self.task = task
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    func start() {
        let listsChoiseController = assemblyBuilder.createListsChoiseController(coordinator: self, for: task)
        
        listsChoiseController.modalPresentationStyle = .custom
        
        let presentationManager = PresentationManager()
        listsChoiseController.transitioningDelegate = presentationManager
        
        navigationController.present(listsChoiseController, animated: true, completion: nil)
    }
    
    // MARK: - Handlers
    func viewDidDisappear() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func didFinishListsChoise() {
        navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
        
        didChangeList?()
    }
}
