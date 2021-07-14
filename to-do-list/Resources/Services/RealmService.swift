//
//  RealmService.swift
//  to-do-list
//
//  Created by vlsuv on 14.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmServiceProtocol {
    func get<T: Object>(_ object: T.Type) -> Results<T>
    func add<T: Object>(_ object: T, completion: ((Bool) -> ())?)
    func delete<T: Object>(_ object: T, completion: ((Bool) -> ())?)
    
    func writeChange(handler: (() -> ()), completion: ((Bool) -> ())? )
}

class RealmService: RealmServiceProtocol {
    
    // MARK: - Properties
    private var realm = try! Realm()
    
    // MARK: - Handlers
    func get<T: Object>(_ object: T.Type) -> Results<T> {
        return realm.objects(object)
    }
    
    func add<T: Object>(_ object: T, completion: ((Bool) -> ())?) {
        do {
            try realm.write {
                realm.add(object)
            }
            completion?(true)
        } catch {
            completion?(false)
        }
    }
    
    func delete<T: Object>(_ object: T, completion: ((Bool) -> ())?) {
        do {
            try realm.write {
                realm.delete(object)
            }
            completion?(true)
        } catch {
            completion?(false)
        }
    }
    
    func writeChange(handler: (() -> ()), completion: ((Bool) -> ())? ) {
        do {
            try realm.write(handler)
            completion?(true)
        } catch {
            completion?(false)
        }
    }
}
