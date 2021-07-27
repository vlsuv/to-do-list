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
        tableView.rowHeight = Size.mediumCellHeight
        return tableView
    }()
    
    private var newListButton: UIButton = {
        let button = UIButton()
        
        let newListNormalAttributedString = NSAttributedString(string: "New List", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize.title1, weight: .medium),
            NSAttributedString.Key.foregroundColor: Color.baseBlue
        ])
        
        button.setImage(Image.plusIcon.withTintColor(Color.baseBlue), for: .normal)
        
        button.tintColor = Color.baseBlue
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: Space.smallSpace, bottom: 0, right: 0)
        button.setAttributedTitle(newListNormalAttributedString, for: .normal)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    private lazy var taskSearchButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Image.magnifyingglassIcon, style: .plain, target: self, action: #selector(didTapTaskSearchButton(_:)))
        return button
    }()
    
    private lazy var editDoneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapEditDoneButton(_:)))
        return button
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureNewListButton()
        configureTableView()
        configureNavigationController()
        configureLongPressGestureRecognizer()
    }
    
    // MARK: - Targets
    @objc private func didTapNewListButton(_ sender: UIButton) {
        presenter?.inputs.didTapNewList()
    }
    
    @objc private func didTapTaskSearchButton(_ sender: UIBarButtonItem) {
        presenter?.inputs.didTapTaskSearch()
    }
    
    @objc private func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: tableView)
        
        let indexPath = tableView.indexPathForRow(at: location)
        
        guard sender.state == .began, indexPath == nil, !tableView.isEditing else { return }
        
        tableView.setEditing(true, animated: true)
        
        changeEditDoneButtonState(isHidden: false)
    }
    
    @objc private func didTapEditDoneButton(_ sender: UIBarButtonItem) {
        tableView.setEditing(false, animated: true)
        
        changeEditDoneButtonState(isHidden: true)
    }
    
    // MARK: - Configures
    private func configureNavigationController() {
        navigationItem.rightBarButtonItem = taskSearchButton
        
        navigationController?.toTransparent()
        navigationController?.navigationBar.tintColor = Color.darkGray
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
                             paddingLeft: Space.mediumSpace,
                             paddingRight: Space.mediumSpace,
                             height: Size.mediumCellHeight)
    }
    
    private func configureLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Helpers
    func changeEditDoneButtonState(isHidden: Bool) {
        if isHidden {
            navigationItem.rightBarButtonItem = taskSearchButton
        } else {
            navigationItem.rightBarButtonItem = editDoneButton
        }
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
        deleteAction.image = Image.trashIcon?.withTintColor(Color.white)
        deleteAction.backgroundColor = Color.red
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] action, view, completion in
            
            self?.presenter?.inputs.didTapEditList(at: indexPath)
            
            completion(true)
        }
        editAction.image = Image.pencilIcon?.withTintColor(Color.white)
        editAction.backgroundColor = Color.mediumGray
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
