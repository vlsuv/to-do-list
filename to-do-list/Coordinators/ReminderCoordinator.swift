//
//  ReminderCoordinator.swift
//  to-do-list
//
//  Created by vlsuv on 19.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class ReminderCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    private var navigationController: UINavigationController?
    
    private var viewController: UIViewController?
    
    private let assemblyBuilder: AssemblyModuleBuilderProtocol
    
    var didSelectDate: ((Date) -> ())?
       
    // MARK: - Init
    init(navigationController: UINavigationController? = nil, viewController: UIViewController? = nil, assemblyBuilder: AssemblyModuleBuilderProtocol = AssemblyModuleBuilder()) {
        self.navigationController = navigationController
        self.viewController = viewController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func start() {
        let reminderController = assemblyBuilder.createReminderController(coordinator: self)
        
        reminderController.modalPresentationStyle = .custom
        reminderController.transitioningDelegate = navigationController
        
        if let navigationController = navigationController {
            navigationController.present(reminderController, animated: true, completion: nil)
        } else if let viewController = viewController {
            viewController.present(reminderController, animated: true, completion: nil)
        }
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Handlers
    func viewDidDisappear() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func didChoiseDate(_ date: Date) {
        didSelectDate?(date)
        
        if let navigationController = navigationController {
            navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
        } else if let viewController = viewController {
            viewController.presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
