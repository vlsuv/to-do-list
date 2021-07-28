//
//  ListMoreDetailPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 27.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol ListMoreDetailViewProtocol: class {
    
}

protocol ListMoreDetailPresenterInputs {
    func viewDidDisappear()
}

protocol ListMoreDetailPresenterOutputs {
    var sections: [ListMoreDetailSection] { get set }
}

protocol ListMoreDetailPresenterType {
    var inputs: ListMoreDetailPresenterInputs { get }
    var outputs: ListMoreDetailPresenterOutputs { get }
}

enum ListMoreDetailCompletionAction {
    case renameList
    case deleteList
    case deleteAllCompletedTasks
}

class ListMoreDetailPresenter: ListMoreDetailPresenterType, ListMoreDetailPresenterInputs, ListMoreDetailPresenterOutputs {
    
    // MARK: - Properties
    var inputs: ListMoreDetailPresenterInputs { return self }
    var outputs: ListMoreDetailPresenterOutputs { return self }
    
    private weak var view: ListMoreDetailViewProtocol?
    
    private let coordinator: ListMoreDetailCoordinator
    
    var sections: [ListMoreDetailSection] = []
    
    var completion: ((ListMoreDetailCompletionAction) -> ())?
    
    // MARK: - Init
    init(view: ListMoreDetailViewProtocol, coordinator: ListMoreDetailCoordinator) {
        self.view = view
        self.coordinator = coordinator
        
        configureSections()
    }
    
    // MARK: - Deinit
    deinit {
        print("deinit: \(self)")
    }
    
    func viewDidDisappear() {
        coordinator.viewDidDisappear()
    }
    
    // MARK: - Confgiures
    private func configureSections() {
        let renameListOption = ListMoreDetailStaticCellOption(title: "Rename list") { [weak self] in
            self?.completion?(.renameList)
        }
        let deleteListOption = ListMoreDetailStaticCellOption(title: "Delete list") { [weak self] in
            self?.completion?(.deleteList)
        }
        let deleteAllCompletedTasksOption = ListMoreDetailStaticCellOption(title: "Delete all completed tasks") { [weak self] in
            self?.completion?(.deleteAllCompletedTasks)
        }
        
        sections = [ListMoreDetailSection(title: "List manage", options: [.ListMoreDetailStaticCell(model: renameListOption), .ListMoreDetailStaticCell(model: deleteListOption), .ListMoreDetailStaticCell(model: deleteAllCompletedTasksOption)])]
    }
    
    
}
