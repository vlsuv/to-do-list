//
//  ListsController.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RealmSwift

class ListsController: UIViewController {
    
    // MARK: - Properties
    var presenter: ListsPresenterType?
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 48
        return tableView
    }()
    
    private var newListButton: UIButton = {
        let button = UIButton()
        
        let newListNormalAttributedString = NSAttributedString(string: "New List", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium),
            NSAttributedString.Key.foregroundColor: Color.baseBlue
        ])
        
        button.setImage(Image.plusIcon, for: .normal)
        
        button.tintColor = Color.baseBlue
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.setAttributedTitle(newListNormalAttributedString, for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureNewListButton()
        configureTableView()
        configureNavigationController()
    }
    
    // MARK: - Targets
    @objc private func didTapEditButton(_ sender: UIBarButtonItem) {
        tableView.isEditing.toggle()
    }
    
    @objc private func didTapNewListButton(_ sender: UIButton) {
        presenter?.inputs.didTapNewList()
    }
    
    @objc private func didTapTaskSearchButton(_ sender: UIBarButtonItem) {
        presenter?.inputs.didTapTaskSearch()
    }
    
    // MARK: - Configures
    private func configureNavigationController() {
        let taskSearchButton = UIBarButtonItem(image: Image.magnifyingglassIcon, style: .plain, target: self, action: #selector(didTapTaskSearchButton(_:)))
        navigationItem.rightBarButtonItem = taskSearchButton
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapEditButton(_:)))
        navigationItem.leftBarButtonItem = editButton
        
        navigationController?.toTransparent()
        navigationController?.navigationBar.tintColor = Color.baseBlue
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         bottom: newListButton.topAnchor)
    }
    
    private func configureNewListButton() {
        newListButton.addTarget(self, action: #selector(didTapNewListButton(_:)), for: .touchUpInside)
        
        view.addSubview(newListButton)
        newListButton.anchor(left: view.leftAnchor,
                             right: view.rightAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             paddingLeft: 18,
                             paddingRight: 18,
                             height: 48)
    }
}

// MARK: - ListsViewProtocol
extension ListsController: ListsViewProtocol {
    func updateView() {
        tableView.reloadData()
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        tableView.reloadRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
    
    func deleteRows(at indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        tableView.deleteRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
    
    func insertRows(at indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
}

// MARK: - UITableViewDataSource
extension ListsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.outputs.lists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else { return UITableViewCell() }
        
        if let list = presenter?.outputs.lists?[indexPath.row] {
            cell.configure(list)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter?.inputs.didSelectList(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter?.inputs.didMoveList(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
            
            self?.presenter?.inputs.didTapDeleteList(at: indexPath)
            
            completion(true)
        }
        deleteAction.image = Image.trashIcon
        deleteAction.backgroundColor = Color.red
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] action, view, completion in
            
            self?.presenter?.inputs.didTapEditList(at: indexPath)
            
            completion(true)
        }
        editAction.image = Image.pencilIcon
        editAction.backgroundColor = Color.mediumGray
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
