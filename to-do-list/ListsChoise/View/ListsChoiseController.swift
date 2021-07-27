//
//  ListsChoiseController.swift
//  to-do-list
//
//  Created by vlsuv on 19.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class ListsChoiseController: UIViewController {
    
    // MARK: - Properties
    var presenter: ListsChoisePresenterType?
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var pointOrigin: CGPoint?
    
    private var pointOriginIsSetted: Bool = false
    
    private var elementsHeight: CGFloat {
        return tableView.contentSize.height + 36
    }
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureTableView()
        configurePanGestureRecognizer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let containerHeight = presentationController?.containerView?.frame.height else { return }
        
        view.frame.origin = CGPoint(x: 0, y: containerHeight - elementsHeight)
        
        if !pointOriginIsSetted {
            pointOrigin = view.frame.origin
            
            pointOriginIsSetted = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.inputs.viewDidDisappear()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Targets
    @objc private func panGestureRecognizerAction(_ sender: UIPanGestureRecognizer) {
        guard let pointOrigin = pointOrigin else { return }
        
        let translation = sender.translation(in: view)
        
        let currentYPosition = pointOrigin.y + translation.y
        
        if currentYPosition >= pointOrigin.y - (elementsHeight / 2) {
            UIView.animate(withDuration: 1) {
                self.view.frame.origin = CGPoint(x: 0, y: currentYPosition)
            }
        }
        
        guard sender.state == .ended else { return }
        
        let dragVelocity = sender.velocity(in: view)
        
        if dragVelocity.y >= 1300 {
            self.dismiss(animated: true, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin = pointOrigin
            }
        }
    }
    
    // MARK: - Configures
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ListChoiseCell.self, forCellReuseIdentifier: ListChoiseCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         bottom: view.bottomAnchor)
    }
    
    private func configurePanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
}

// MARK: - ListsChoiseViewProtocol
extension ListsChoiseController: ListsChoiseViewProtocol {
    
}

// MARK: - UITableViewDataSource
extension ListsChoiseController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.outputs.lists.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListChoiseCell.identifier, for: indexPath) as? ListChoiseCell, let list = presenter?.outputs.lists[indexPath.row] else { return UITableViewCell() }
        cell.configure(list, owner: presenter!.outputs.owner(list: list))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListsChoiseController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter?.inputs.didSelectList(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createListChoiseHeaderView(for: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
}

// MARK: - Helpers
extension ListsChoiseController {
    private func createListChoiseHeaderView(for section: Int) -> UIView? {
        guard section == 0 else { return nil }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 38))
        let label = UILabel(frame: CGRect(x: 18, y: 0, width: view.frame.width, height: view.frame.height))
        
        label.text = "Move task to"
        label.textColor = Color.darkGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        
        view.addSubview(label)
        
        return view
    }
}
