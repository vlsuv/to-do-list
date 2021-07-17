//
//  DataManager.swift
//  to-do-list
//
//  Created by vlsuv on 14.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RealmSwift

protocol DataManagerProtocol {
    func getLists() -> Results<ListModel>
    func addObserveForLists(block: @escaping (RealmCollectionChange<Results<ListModel>>) -> ())
    func addList(title: String, completion: ((Bool) -> ())?)
    func deleteList(_ object: ListModel, completion: ((Bool) -> ())?)
    
    func getAllTasks() -> Results<Task>
    func deleteTask(_ object: Task, completion: ((Bool) -> ())?)
    
    func toChange(handler: (() -> ()), completion: ((Bool) -> ())?)
}

class DataManager: DataManagerProtocol {
    
    // MARK: - Properties
    static let shared: DataManagerProtocol = DataManager()
    
    private let realmService: RealmServiceProtocol
    
    private var lists: Results<ListModel>
    
    private var listsObserver: NotificationToken?
    
    // MARK: - Init
    private init() {
        self.realmService = RealmService()
        
        lists = realmService.get(ListModel.self).sorted(byKeyPath: "order", ascending: true)
    }
}

// MARK: - Lists Manage
extension DataManager {
    func getLists() -> Results<ListModel> {
        return lists
    }
    
    func addObserveForLists(block: @escaping (RealmCollectionChange<Results<ListModel>>) -> ()) {
        listsObserver = lists.observe(block)
    }
    
    func addList(title: String, completion: ((Bool) -> ())?) {
        let newList: ListModel
        
        if let lastList = lists.last {
            newList = ListModel(title: title, order: lastList.order + 1)
        } else {
            newList = ListModel(title: title, order: 1)
        }
        
        realmService.add(newList, completion: completion)
    }
    
    func deleteList(_ object: ListModel, completion: ((Bool) -> ())?) {
        realmService.delete(object, completion: completion)
    }
}

// MARK: - Tasks Manage
extension DataManager {
    func getAllTasks() -> Results<Task> {
        return realmService.get(Task.self)
    }
    
    func deleteTask(_ object: Task, completion: ((Bool) -> ())?) {
        realmService.delete(object, completion: completion)
    }
}

// MARK: - Data Helpers
extension DataManager {
    func toChange(handler: (() -> ()), completion: ((Bool) -> ())?) {
        realmService.writeChange(handler: handler, completion: completion)
    }
}
