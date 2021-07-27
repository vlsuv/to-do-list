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
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(presenter?.outputs.markOfDone, for: .normal)
        button.setTitleColor(Color.baseBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: FontSize.title2, weight: .medium)
        button.addTarget(self, action: #selector(didTapDoneButton(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureNavigationController()
        configureDoneButton()
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
    @objc private func didTapDeleteButton(_ sender: UIBarButtonItem) {
        presenter?.inputs.didTapDeleteTask()
    }
    
    @objc private func didTapDoneButton(_ sender: UIBarButtonItem) {
        presenter?.inputs.didTapDone()
    }
    
    // MARK: - Configures
    private func configureNavigationController() {
        let deleteButton = UIBarButtonItem(image: Image.trashIcon, style: .done, target: self, action: #selector(didTapDeleteButton(_:)))
        
        navigationItem.rightBarButtonItem = deleteButton
        navigationItem.backBarButtonItem?.tintColor = Color.mediumGray
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(EditTaskTitleTextViewCell.self, forCellReuseIdentifier: EditTaskTitleTextViewCell.identifier)
        tableView.register(EditTaskTextViewCell.self, forCellReuseIdentifier: EditTaskTextViewCell.identifier)
        tableView.register(EditTaskListCell.self, forCellReuseIdentifier: EditTaskListCell.identifier)
        tableView.register(EditTaskReminderCell.self, forCellReuseIdentifier: EditTaskReminderCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         bottom: doneButton.topAnchor)
    }
    
    private func configureDoneButton() {
        view.addSubview(doneButton)
        doneButton.anchor(right: view.rightAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          paddingRight: Space.mediumSpace,
                          height: Size.mediumCellHeight)
    }
}

// MARK: - EditTaskViewProtocol
extension EditTaskController: EditTaskViewProtocol {
    func updateView() {
        tableView.reloadData()
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        tableView.reloadRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
}

// MARK: - UITableViewDataSource
extension EditTaskController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.outputs.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = presenter?.outputs.sections[section]
        
        return section?.option.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = presenter?.outputs.sections[indexPath.section].option[indexPath.row] else {
            return UITableViewCell()
        }
        
        switch section {
        case .EditTaskTitleTextViewCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditTaskTitleTextViewCell.identifier, for: indexPath) as? EditTaskTitleTextViewCell else { return UITableViewCell() }
            cell.configure(model)
            cell.delegate = self
            return cell
        case .EditTaskTextViewCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditTaskTextViewCell.identifier, for: indexPath) as? EditTaskTextViewCell else { return UITableViewCell() }
            cell.configure(model)
            cell.delegate = self
            return cell
        case .EditTaskListCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditTaskListCell.identifier, for: indexPath) as? EditTaskListCell else { return UITableViewCell() }
            cell.configure(model)
            return cell
        case .EditTaskReminderCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditTaskReminderCell.identifier, for: indexPath) as? EditTaskReminderCell else { return UITableViewCell() }
            cell.configure(model)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension EditTaskController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = presenter?.outputs.sections[indexPath.section].option[indexPath.row] else { return }
        
        switch section {
        case .EditTaskListCell(model: let model):
            model.handler?()
        case .EditTaskReminderCell(model: let model):
            model.handler?()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = presenter?.outputs.sections[indexPath.section].option[indexPath.row] else { return Size.mediumCellHeight }
        
        switch section {
        case .EditTaskTextViewCell(model: _):
            return UITableView.automaticDimension
        case .EditTaskTitleTextViewCell(model: _):
            return UITableView.automaticDimension
        default:
            return Size.mediumCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.largeCellHeight
    }
}

// MARK: - EditTaskTextViewCellDelegate
extension EditTaskController: EditTaskTextViewCellDelegate {
    func didChangeText(cell: EditTaskTextViewCell, text: String) {
        guard let indexPath = tableView.indexPath(for: cell), let section = presenter?.outputs.sections[indexPath.section].option[indexPath.row] else { return }
        
        switch section {
        case .EditTaskTextViewCell(model: let model):
            tableView.beginUpdates()
            tableView.endUpdates()
            model.handler?(text)
        default:
            return
        }
    }
}

// MARK: - EditTaskReminderCellDelegate
extension EditTaskController: EditTaskReminderCellDelegate {
    func didTapReminderButton(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell), let section = presenter?.outputs.sections[indexPath.section].option[indexPath.row] else { return }
        
        switch section {
        case .EditTaskReminderCell(model: let model):
            model.handler?()
        default:
            return
        }
    }
    
    func didTapCancelReminderButton(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell), let section = presenter?.outputs.sections[indexPath.section].option[indexPath.row] else { return }
        
        switch section {
        case .EditTaskReminderCell(model: let model):
            model.cancelHandler?()
        default:
            return
        }
    }
}

// MARK: - EditTaskTitleTextViewCellDelegate
extension EditTaskController: EditTaskTitleTextViewCellDelegate {
    func didChangeText(cell: UITableViewCell, text: String) {
        guard let indexPath = tableView.indexPath(for: cell), let section = presenter?.outputs.sections[indexPath.section].option[indexPath.row] else { return }
        
        switch section {
        case .EditTaskTitleTextViewCell(model: let model):
            tableView.beginUpdates()
            tableView.endUpdates()
            model.handler?(text)
        default:
            return
        }
    }
}
