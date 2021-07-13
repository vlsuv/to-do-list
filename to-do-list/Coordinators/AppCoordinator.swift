//
//  AppCoordinator.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    
    private let window: UIWindow
    
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    // MARK: - Init
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let listsCoordinator = ListsCoordinator(navigationController: navigationController)
        childCoordinators.append(listsCoordinator)
        listsCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    // MARK: - Handlers
    func childDidFinish(_ childCoordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { childCoordinator === $0 }) else { return }
        
        childCoordinators.remove(at: index)
    }
}
