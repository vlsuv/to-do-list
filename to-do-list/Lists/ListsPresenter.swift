//
//  ListsPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

protocol ListsViewProtocol: class {
    func insertRows(at indexPaths: [IndexPath])
    func deleteRows(at indexPaths: [IndexPath])
}

protocol ListsPresenterOutputs {
    var lists: [List] { get set }
}

protocol ListsPresenterInputs {
    func didTapNewList()
    func didMoveList(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath)
    func didDeleteList(at indexPath: IndexPath)
    func didSelectList(at indexPath: IndexPath)
}

protocol ListsPresenterType {
    var inputs: ListsPresenterInputs { get }
    var outputs: ListsPresenterOutputs { get }
}

class ListsPresenter: ListsPresenterType, ListsPresenterInputs, ListsPresenterOutputs {
    
    // MARK: - Properties
    var inputs: ListsPresenterInputs { return self }
    var outputs: ListsPresenterOutputs { return self }
    
    private var coordinator: ListsCoordinator
    
    private weak var view: ListsViewProtocol?
    
    var lists: [List] = [List]()
    
    // MARK: - Init
    init(view: ListsViewProtocol, coordinator: ListsCoordinator) {
        self.coordinator = coordinator
        self.view = view
        
        getLists()
    }
    
    // MARK: - Lists Handlers
    private func getLists() {
        lists = [List(title: "order 0", order: 0), List(title: "order 1", order: 1)]
    }
    
    func didTapNewList() {
        if let lastList = lists.last {
            lists.append(List(title: "order \(lastList.order + 1)", order: lastList.order + 1))
        } else {
            lists.append(List(title: "order \(0)", order: 0))
        }
        
        let indexPath = IndexPath(row: lists.count - 1, section: 0)
        view?.insertRows(at: [indexPath])
    }
    
    func didMoveList(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        
        let sourceList = lists[sourceIndexPath.row]
        let destinationList = lists[destinationIndexPath.row]
        
        swap(&sourceList.order, &destinationList.order)
    }
    
    func didDeleteList(at indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        
        view?.deleteRows(at: [indexPath])
    }
    
    func didSelectList(at indexPath: IndexPath) {
        let list = lists[indexPath.row]
        
        print(list)
        
        coordinator.showTasks()
    }
}
