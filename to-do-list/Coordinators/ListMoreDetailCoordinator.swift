//
//  ListMoreDetailCoordinator.swift
//  to-do-list
//
//  Created by vlsuv on 27.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class ListMoreDetailCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    private let navigationController: UINavigationController
    
    private let assemblyBuilder: AssemblyModuleBuilderProtocol
    
    var completion: ((ListMoreDetailCompletionAction) -> ())?
    
    // MARK: - Init
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol = AssemblyModuleBuilder(), completion: ((ListMoreDetailCompletionAction) -> ())?) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
        self.completion = completion
    }
    
    // MARK: - Deinit
    func viewDidDisappear() {
        parentCoordinator?.childDidFinish(self)
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Handlers
    func start() {
        let completionHandler: (ListMoreDetailCompletionAction) -> () = { [weak self] action in
            self?.navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
            
            self?.completion?(action)
        }
        
        let listMoreDetailController = assemblyBuilder.createListMoreDetailController(coordinator: self, completion: completionHandler)
        
        let presentationManager = PresentationManager()
        
        listMoreDetailController.modalPresentationStyle = .custom
        listMoreDetailController.transitioningDelegate = presentationManager
        
        navigationController.present(listMoreDetailController, animated: true, completion: nil)
    }
}
