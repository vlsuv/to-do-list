//
//  ReminderController.swift
//  to-do-list
//
//  Created by vlsuv on 19.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class ReminderController: UIViewController {
    
    // MARK: - Properties
    var presenter: ReminderPresenterType?
    
    private var contentView: ReminderContentView = {
        let view = ReminderContentView()
        return view
    }()
    
    private var pointOrigin: CGPoint?
    
    private var pointOriginIsSetted: Bool = false
    
    private var elementsHeight: CGFloat {
        return contentView.datePicker.frame.height + contentView.doneButton.frame.height + 54
    }
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        addTargets()
        configureMovePanGestureRecognier()
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
    @objc private func didTapDoneButton(_ sender: UIButton) {
        presenter?.inputs.didTapDone(with: contentView.datePicker.date)
    }
    
    // MARK: - Configures
    private func configureContentView() {
        view.addSubview(contentView)
        contentView.frame = view.bounds
    }
    
    private func addTargets() {
        contentView.doneButton.addTarget(self, action: #selector(didTapDoneButton(_:)), for: .touchUpInside)
    }
}

// MARK: - ReminderViewProtocol
extension ReminderController: ReminderViewProtocol {
    
}

// MARK: - View Moving
extension ReminderController {
    private func configureMovePanGestureRecognier() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
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
}
