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
    func getLists() -> Results<List>
    func addObserveForLists(block: @escaping (RealmCollectionChange<Results<List>>) -> ())
    func addList(title: String, completion: ((Bool) -> ())?)
    func deleteList(_ object: List, completion: ((Bool) -> ())?)
    
    func toChange(handler: (() -> ()), completion: ((Bool) -> ())?)
}

class DataManager: DataManagerProtocol {
    
    // MARK: - Properties
    static let shared: DataManagerProtocol = DataManager()
    
    private let realmService: RealmServiceProtocol
    
    private var lists: Results<List>
    
    private var listsObserver: NotificationToken?
    
    // MARK: - Init
    private init() {
        self.realmService = RealmService()
        
        lists = realmService.get(List.self).sorted(byKeyPath: "order", ascending: true)
    }
}

// MARK: - Lists Manage
extension DataManager {
    func getLists() -> Results<List> {
        return lists
    }
    
    func addObserveForLists(block: @escaping (RealmCollectionChange<Results<List>>) -> ()) {
        listsObserver = lists.observe(block)
    }
    
    func addList(title: String, completion: ((Bool) -> ())?) {
        let newList: List
        
        if let lastList = lists.last {
            newList = List(title: title, order: lastList.order + 1)
        } else {
            newList = List(title: title, order: 1)
        }
        
        realmService.add(newList, completion: completion)
    }
    
    func deleteList(_ object: List, completion: ((Bool) -> ())?) {
        realmService.delete(object, completion: completion)
    }
}

// MARK: - Data Helpers
extension DataManager {
    func toChange(handler: (() -> ()), completion: ((Bool) -> ())?) {
        realmService.writeChange(handler: handler, completion: completion)
    }
}
