//
//  Coordinator.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get }
    func childDidFinish(_ childCoordinator: Coordinator)
    
    func start()
}
extension Coordinator {
    func childDidFinish(_ childCoordinator: Coordinator) {}
}
