//
//  TasksController.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class TasksController: UIViewController {
    
    // MARK: - Properties
    var presenter: TasksPresenterType?
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.inputs.viewDidDisappear()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Configure
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
}

// MARK: - TasksViewProtocol
extension TasksController: TasksViewProtocol {
    func insertRows(at indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .bottom)
    }
    
    func deleteRows(at indexPaths: [IndexPath]) {
        tableView.deleteRows(at: indexPaths, with: .bottom)
    }
    
    func updateView() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension TasksController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.outputs.taskSections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = presenter?.outputs.taskSections[section] else { return 0 }
        
        if section.isExpand {
            return section.tasks.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = presenter?.outputs.taskSections[indexPath.section] else { return UITableViewCell() }
        
        let sectionTitleIndex = indexPath.row == 0
        let index = indexPath.row - 1
        
        if sectionTitleIndex {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = section.title
            cell.accessoryType = .disclosureIndicator
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else { return UITableViewCell() }
            
            cell.configure(section.tasks[index])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension TasksController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter?.inputs.didSelectTask(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row > 0, indexPath.section == 0 else { return nil }
        
        let doneAction = UIContextualAction(style: .destructive, title: "Done") { [weak self] action, view, completion in
            
            self?.presenter?.inputs.didTapDone(at: indexPath)
            
            completion(true)
        }
        doneAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
}
