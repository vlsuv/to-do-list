//
//  EditTaskController.swift
//  to-do-list
//
//  Created by vlsuv on 17.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class EditTaskController: UIViewController {
    
    // MARK: - Properties
    var presenter: EditTaskPresenterType?
    
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureNavigationController()
        configureTableView()
    }
    
    // MARK: - Targets
    @objc private func didTapDeleteButton(_ sender: UIBarButtonItem) {
        presenter?.inputs.didTapDeleteTask()
    }
    
    // MARK: - Configures
    private func configureNavigationController() {
        let deleteButton = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(didTapDeleteButton(_:)))
        
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.inputs.viewDidDisappear()
    }
    
    deinit {
        print("deinit: \(self)")
    }
}

// MARK: - EditTaskViewProtocol
extension EditTaskController: EditTaskViewProtocol {
    
}

// MARK: - UITableViewDataSource
extension EditTaskController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension EditTaskController: UITableViewDelegate {
    
}
