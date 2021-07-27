//
//  ListsChoisePresenter.swift
//  to-do-list
//
//  Created by vlsuv on 19.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RealmSwift

protocol ListsChoiseViewProtocol: class {
    
}

protocol ListsChoisePresenterInputs {
    func viewDidDisappear()
    func didSelectList(at indexPath: IndexPath)
}

protocol ListsChoisePresenterOutputs {
    var lists: Results<ListModel> { get set }
    func owner(list: ListModel) -> Bool 
}

protocol ListsChoisePresenterType {
    var inputs: ListsChoisePresenterInputs { get }
    var outputs: ListsChoisePresenterOutputs { get }
}

class ListsChoisePresenter: ListsChoisePresenterType, ListsChoisePresenterInputs, ListsChoisePresenterOutputs {
    
    // MARK: - Properties
    var inputs: ListsChoisePresenterInputs { return self }
    var outputs: ListsChoisePresenterOutputs { return self }
    
    private weak var view: ListsChoiseViewProtocol?
    
    private var coordinator: ListsChoiseCoordinator?
    
    private let task: Task
    
    var lists: Results<ListModel>
    
    // MARK: - Init
    init(view: ListsChoiseViewProtocol, coordinator: ListsChoiseCoordinator, task: Task) {
        self.view = view
        self.coordinator = coordinator
        self.task = task
        
        lists = DataManager.shared.getLists()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Handlers
    private func changeParentList(from ownerList: ListModel, to list: ListModel) {
        guard let taskIndex = ownerList.tasks.firstIndex(of: task) else { return }
        
        DataManager.shared.toChange(handler: {
            ownerList.tasks.remove(at: taskIndex)
            
            task.owner = list
            
            list.tasks.append(task)
        }) { [weak self] isChanged in
            if isChanged {
                self?.coordinator?.didFinishListsChoise()
            }
        }
    }
    
    // MARK: - Inputs Handlers
    func viewDidDisappear() {
        coordinator?.viewDidDisappear()
    }
    
    func didSelectList(at indexPath: IndexPath) {
        let destinationList = lists[indexPath.row]
        
        guard let owner = task.owner, owner != destinationList else { return }
        
        changeParentList(from: owner, to: destinationList)
    }
    
    func owner(list: ListModel) -> Bool {
        return task.owner == list
    }
}
