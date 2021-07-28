//
//  ListMoreDetailController.swift
//  to-do-list
//
//  Created by vlsuv on 27.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class ListMoreDetailController: UIViewController {
    
    // MARK: - Properties
    var presenter: ListMoreDetailPresenter?
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 38
        return tableView
    }()
    
    private var pointOrigin: CGPoint?
    
    private var pointOriginIsSetted: Bool = false
    
    private var elementsHeight: CGFloat {
        return tableView.contentSize.height + Space.mediumSpace
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
    
    // MARK: - Deinit
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
        
        tableView.register(ListDetailStaticCell.self, forCellReuseIdentifier: ListDetailStaticCell.identifier)
        
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

// MARK: - ListMoreDetailViewProtocol
extension ListMoreDetailController: ListMoreDetailViewProtocol {
    
}

// MARK: - UITableViewDataSource
extension ListMoreDetailController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.outputs.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.outputs.sections[section].options.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListDetailStaticCell.identifier, for: indexPath) as? ListDetailStaticCell, let section = presenter?.outputs.sections[indexPath.section].options[indexPath.row] else {
            return UITableViewCell()
        }
        
        switch section {
        case .ListMoreDetailStaticCell(model: let model):
            cell.configure(model)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListMoreDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = presenter?.outputs.sections[indexPath.section].options[indexPath.row] else {
            return
        }
        
        switch  section {
        case .ListMoreDetailStaticCell(model: let model):
            model.handler?()
        }
    }
}
