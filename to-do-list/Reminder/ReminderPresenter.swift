//
//  ReminderPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 19.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol ReminderViewProtocol: class {
    
}

protocol ReminderPresenterInputs {
    func viewDidDisappear()
    func didTapDone(with date: Date)
}

protocol ReminderPresenterOutputs {
    
}

protocol ReminderPresenterType {
    var inputs: ReminderPresenterInputs { get }
    var outputs: ReminderPresenterOutputs { get }
}

class ReminderPresenter: ReminderPresenterType, ReminderPresenterInputs, ReminderPresenterOutputs {
    
    // MARK: - Properties
    var inputs: ReminderPresenterInputs { return self }
    var outputs: ReminderPresenterOutputs { return self }
    
    private weak var view: ReminderViewProtocol?
    
    private var coordinator: ReminderCoordinator
    
    // MARK: - Init
    init(view: ReminderViewProtocol, coordinator: ReminderCoordinator) {
        self.view = view
        self.coordinator = coordinator
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Inputs Handlers
    func viewDidDisappear() {
        coordinator.viewDidDisappear()
    }
    
    func didTapDone(with date: Date) {
        coordinator.didChoiseDate(date)
    }
}
