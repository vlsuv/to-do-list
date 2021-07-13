//
//  AssemblyModuleBuilder.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol AssemblyModuleBuilderProtocol {
    func createListsController(coordinator: ListsCoordinator) -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    func createListsController(coordinator: ListsCoordinator) -> UIViewController {
        let view = ListsController()
        let presenter = ListsPresenter(view: view, coordinator: coordinator)
        view.presenter = presenter
        return view
    }
}
