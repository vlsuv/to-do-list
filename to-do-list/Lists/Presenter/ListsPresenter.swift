//
//  ListsPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol ListsViewProtocol: class {
    func insertRows(at indexPaths: [IndexPath])
    func deleteRows(at indexPaths: [IndexPath])
    func reloadRows(at indexPaths: [IndexPath])
    func updateView()
}

protocol ListsPresenterOutputs {
    var lists: Results<ListModel>? { get set }
}

protocol ListsPresenterInputs {
    func didTapNewList()
    func didMoveList(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath)
    func didTapDeleteList(at indexPath: IndexPath)
    func didTapEditList(at indexPath: IndexPath)
    func didSelectList(at indexPath: IndexPath)
    func didTapTaskSearch()
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
    
    var lists: Results<ListModel>?
    
    // Cell was moved while editing table view
    private var isMoved: Bool = false
    
    // MARK: - Init
    init(view: ListsViewProtocol, coordinator: ListsCoordinator) {
        self.coordinator = coordinator
        self.view = view
        
        addListsObserver()
    }
    
    // MARK: - Configures
    func addListsObserver() {
        DataManager.shared.addObserveForLists { [weak self] changes in
            
            switch changes {
            case .initial(let lists):
                self?.lists = lists
                
                self?.view?.updateView()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                
                guard self?.isMoved == false else {
                    self?.isMoved = false
                    return
                }
                
                if deletions.count > 0 {
                    self?.view?.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                }
                if insertions.count > 0 {
                    self?.view?.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}))
                }
                if modifications.count > 0 {
                    self?.view?.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}))
                }
                
            case .error(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: - Inputs Handlers
    func didTapNewList() {
        coordinator.showNewList(with: nil)
    }
    
    func didMoveList(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath, let lists = lists else { return }
        
        self.isMoved = true
        
        DataManager.shared.toChange(handler: {
            let sourceList = lists[sourceIndexPath.row]
            let destinationList = lists[destinationIndexPath.row]
            
            swap(&sourceList.order, &destinationList.order)
        }) { isChanged in
            if isChanged {
                print("List is changed")
            }
        }
    }
    
    func didTapDeleteList(at indexPath: IndexPath) {
        guard let list = lists?[indexPath.row] else { return }
        
        DataManager.shared.deleteList(list, completion: nil)
    }
    
    func didTapEditList(at indexPath: IndexPath) {
        guard let list = lists?[indexPath.row] else { return }
        
        coordinator.showNewList(with: list)
    }
    
    func didSelectList(at indexPath: IndexPath) {
        guard let list = lists?[indexPath.row] else { return }
        
        coordinator.showTasks(for: list)
    }

    func didTapTaskSearch() {
        coordinator.showTaskSearch()
    }
}
