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
    
    private lazy var addNewTaskButton: UIButton = {
        let button = UIButton()
        let buttonImage = Image.plusCircleFillIcon?.withTintColor(Color.baseBlue)
        button.setImage(buttonImage, for: .normal)
        
        button.tintColor = Color.baseBlue
        button.layer.shadowColor = Color.black.withAlphaComponent(0.3).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
        button.layer.masksToBounds = false
        
        button.addTarget(self, action: #selector(didTapNewTaskButton(_:)), for: .touchUpInside)
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
        
        configureNavigationController()
        configureTableView()
        configureAddNewTaskButton()
        configureLongPressGestureRecognizer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.inputs.viewDidDisappear()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Targets
    @objc private func didTapNewTaskButton(_ sender: UIBarButtonItem) {
        presenter?.inputs.didTapNewTask()
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
    
    @objc private func didTapListMoreDetailsButton(_ sender: UIBarButtonItem) {
        presenter?.inputs.didTapListMoreDetails()
    }
    
    // MARK: - Configure
    private func configureNavigationController() {
        let listMoreDetailsButton = UIBarButtonItem(image: Image.moreHorizontalIcon?.withTintColor(Color.darkGray), style: .plain, target: self, action: #selector(didTapListMoreDetailsButton(_:)))
        
        navigationItem.rightBarButtonItem = listMoreDetailsButton
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TasksSectionCell.self, forCellReuseIdentifier: TasksSectionCell.identifier)
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         bottom: view.bottomAnchor)
    }
    
    private func configureAddNewTaskButton() {
        view.addSubview(addNewTaskButton)
        
        let addNewTaskButtonSize: CGFloat = Size.largeIconSize
        addNewTaskButton.anchor(right: view.rightAnchor,
                                bottom: view.bottomAnchor,
                                paddingRight: Space.largeSpace,
                                paddingBottom: Space.largeSpace,
                                height: addNewTaskButtonSize,
                                width: addNewTaskButtonSize)
        
        addNewTaskButton.layer.cornerRadius = addNewTaskButtonSize / 2
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
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = editDoneButton
        }
    }
}

// MARK: - TasksViewProtocol
extension TasksController: TasksViewProtocol {
    func updateView() {
        tableView.reloadData()
    }
    
    func reloadSections(_ sections: IndexSet) {
        tableView.beginUpdates()
        tableView.reloadSections(sections, with: .automatic)
        tableView.endUpdates()
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TasksSectionCell.identifier, for: indexPath) as? TasksSectionCell else { return UITableViewCell() }
            cell.configure(section)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else { return UITableViewCell() }
            cell.configure(section.tasks[index])
            cell.delegate = self
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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let section = presenter?.outputs.taskSections[indexPath.section], section.canDone, indexPath.row > 0 else {
            return nil
        }
        
        let doneAction = UIContextualAction(style: .destructive, title: "Done") { [weak self] action, view, completion in
            self?.presenter?.inputs.didTapDone(at: indexPath)
            
            completion(true)
        }
        doneAction.backgroundColor = Color.baseBlue
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let section = presenter?.outputs.taskSections[indexPath.section], section.canMove, indexPath.row > 0 else {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        guard let section = presenter?.outputs.taskSections[proposedDestinationIndexPath.section], section.canMove, proposedDestinationIndexPath.row > 0 else {
            return sourceIndexPath
        }
        
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter?.inputs.didMoveTask(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 0 {
            return UITableView.automaticDimension
        } else {
            return Size.mediumCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.largeCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        
        let view = UIView()
        view.backgroundColor = Color.lightGray
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == 0 else { return 0 }
        
        return 1
    }
}

// MARK: - TaskCellDelegate
extension TasksController: TaskCellDelegate {
    func didTapDoneButton(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        presenter?.inputs.didTapDone(at: indexPath)
    }
}
