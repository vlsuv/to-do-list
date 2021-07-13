//
//  ListsController.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class ListsController: UIViewController {
    
    // MARK: - Properties
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    private var newListButton: UIButton = {
        let button = UIButton()
        button.setTitle("New List", for: .normal)
        button.setTitleColor(Color.black, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    var lists: [List] = [List]()

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        lists = [List(title: "order 0", order: 0), List(title: "order 1", order: 1)]
        
        configureNewListButton()
        configureTableView()
        configureNavigationController()
    }
    
    // MARK: - Targets
    @objc private func didTapEditButton(_ sender: UIBarButtonItem) {
        tableView.isEditing.toggle()
    }
    
    @objc private func didTapNewListButton(_ sender: UIButton) {
        if let lastList = lists.last {
            lists.append(List(title: "order \(lastList.order + 1)", order: lastList.order + 1))
        } else {
            lists.append(List(title: "order \(0)", order: 0))
        }
        
        tableView.insertRows(at: [IndexPath(row: lists.count - 1, section: 0)], with: .bottom)
    }
    
    // MARK: - Configures
    private func configureNavigationController() {
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapEditButton(_:)))
        
        navigationItem.leftBarButtonItem = editButton
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: newListButton.topAnchor)
        
        tableView.separatorStyle = .none
    }
    
    private func configureNewListButton() {
        newListButton.addTarget(self, action: #selector(didTapNewListButton(_:)), for: .touchUpInside)
        
        view.addSubview(newListButton)
        newListButton.anchor(left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 48)
    }
}

// MARK: - UITableViewDataSource
extension ListsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = lists[indexPath.row].title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // show tasks
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let sourceList = lists[sourceIndexPath.row]
        let destinationList = lists[destinationIndexPath.row]
        
        swap(&sourceList.order, &destinationList.order)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
            
            self?.lists.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .bottom)
            
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

