//
//  TaskSearchController.swift
//  to-do-list
//
//  Created by vlsuv on 15.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class TaskSearchController: UIViewController {
    
    // MARK: - Properties
    var presenter: TaskSearchPresenterType?
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        return searchBar
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureNavigationController()
        configureTableView()
        configureSearchBar()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Targets
    @objc private func didTapCancelButton(_ sender: UIBarButtonItem) {
        presenter?.inputs.didTapCancel()
    }
    
    // MARK: - Configures
    private func configureNavigationController() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancelButton(_:)))
        
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.titleView = searchBar
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
}

// MARK: - TaskSearchViewProtocol
extension TaskSearchController: TaskSearchViewProtocol {
    func updateView() {
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension TaskSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.inputs.didChangeSearchText(searchText)
    }
}

// MARK: - UITableViewDataSource
extension TaskSearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.outputs.searchTasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let task = presenter?.outputs.searchTasks?[indexPath.row] {
            cell.textLabel?.text = task.title
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskSearchController: UITableViewDelegate {
}


