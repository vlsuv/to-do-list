//
//  NewListPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 14.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol NewListViewProtocol: class {
    
}

protocol NewListPresenterInputs {
    func viewDidDisappear()
    func didTapDone()
}

protocol NewListPresenterOutputs {
    var sections: [NewListSection] { get set }
}

protocol NewListPresenterType {
    var inputs: NewListPresenterInputs { get }
    var outputs: NewListPresenterOutputs { get }
}

class NewListPresenter: NewListPresenterType, NewListPresenterInputs, NewListPresenterOutputs {
    
    // MARK: - Properties
    var inputs: NewListPresenterInputs { return self }
    var outputs: NewListPresenterOutputs { return self }
    
    private weak var view: NewListViewProtocol?
    
    private var coordinator: NewListCoordinator?
    
    var sections: [NewListSection] = []
    
    var list: List?
    
    var editMode: Bool {
        return list != nil
    }
    
    var listTitle: String = ""
    
    // MARK: - Init
    init(view: NewListViewProtocol, coordinator: NewListCoordinator, list: List?) {
        self.view = view
        self.coordinator = coordinator
        self.list = list
        
        configureEditMode()
        configureSections()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Inputs Handlers
    func viewDidDisappear() {
        coordinator?.viewDidDisappear()
    }
    
    func didTapDone() {
        if editMode {
            DataManager.shared.toChange(handler: {
                list?.title = listTitle
            }) { [weak self] isChanged in
                if isChanged {
                    print("List is changed")
                    
                    self?.coordinator?.didFinishAddNewList()
                }
            }
        } else {
            DataManager.shared.addList(title: listTitle) { [weak self] isAdded in
                if isAdded {
                    self?.coordinator?.didFinishAddNewList()
                }
            }
        }
    }
    
    // MARK: - Configures
    func configureEditMode() {
        if editMode {
            listTitle = list!.title
        }
    }
    
    private func configureSections() {
        let listTitle = TextFieldCellOption(text: self.listTitle, placeholder: "Enter list title") { [weak self] text in
            self?.listTitle = text
        }
        
        let listDescriptionSection = NewListSection(title: "List Description",
                                                    option: [.textFieldCell(model: listTitle)])
        
        sections = [listDescriptionSection]
    }
}
