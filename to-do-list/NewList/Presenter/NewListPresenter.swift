//
//  NewListPresenter.swift
//  to-do-list
//
//  Created by vlsuv on 14.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol NewListViewProtocol: class {
    func changeStateOfDoneButton(isEnabled: Bool)
}

protocol NewListPresenterInputs {
    func viewDidDisappear()
    func didTapDone()
}

protocol NewListPresenterOutputs {
    var sections: [NewListSection] { get set }
    var title: String { get }
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
    
    private var list: ListModel?
    
    private var editMode: Bool {
        return list != nil
    }
    
    var title: String {
        if editMode {
            return "Rename list"
        } else {
            return "Create new list"
        }
    }
    
    private var listTitle: String = ""
    
    var sections: [NewListSection] = []
    
    // MARK: - Init
    init(view: NewListViewProtocol, coordinator: NewListCoordinator, list: ListModel?) {
        self.view = view
        self.coordinator = coordinator
        self.list = list
        
        configureEditMode()
        configureSections()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Configures
    private func configureSections() {
        let listTitleOption = TextFieldCellOption(text: self.listTitle, placeholder: "Enter list title") { [weak self] text in
            self?.listTitle = text
            
            self?.view?.changeStateOfDoneButton(isEnabled: !text.isEmpty)
        }
        
        let listDescriptionSection = NewListSection(title: "List Description", option: [.textFieldCell(model: listTitleOption)])
        
        sections = [listDescriptionSection]
    }
    
    private func configureEditMode() {
        if editMode {
            listTitle = list!.title
        }
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
}
