//
//  NewListController.swift
//  to-do-list
//
//  Created by vlsuv on 14.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class NewListController: UIViewController {
    
    // MARK: - Properties
    var presenter: NewListPresenterType?
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureNavigationController()
        configureTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.inputs.viewDidDisappear()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Targets
    @objc private func didTapDoneButton(_ sender: UIBarButtonItem) {
        presenter?.inputs.didTapDone()
    }
    
    // MARK: - Configures
    private func configureNavigationController() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton(_:)))
        
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
}

// MARK: - NewListViewProtocol
extension NewListController: NewListViewProtocol {
    
}

// MARK: - UITableViewDataSource
extension NewListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.outputs.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.outputs.sections[section].option.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = presenter?.outputs.sections[indexPath.section].option[indexPath.row] else { return UITableViewCell() }
        
        switch section {
        case .textFieldCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: indexPath) as? TextFieldCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(model)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension NewListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

// MARK: - TextFieldCellDelegate
extension NewListController: TextFieldCellDelegate {
    func didChangeText(cell: TextFieldCell, textField: UITextField) {
        guard let text = textField.text, let indexPath = tableView.indexPath(for: cell), let section = presenter?.outputs.sections[indexPath.section].option[indexPath.row] else {
            return
        }
        
        switch section {
        case .textFieldCell(model: let model):
            model.handler?(text)
        }
    }
}
