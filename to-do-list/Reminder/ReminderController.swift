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
    
    private var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(Color.black, for: .normal)
        return button
    }()
    
    private var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        return datePicker
    }()
    
    var pointOrigin: CGPoint?
    var pointOriginIsSetted: Bool = false
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureDoneButton()
        configureDatePicker()
        configurePanGestureRecognizer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let containerHeight = presentationController?.containerView?.frame.height else { return }
        
        view.frame.origin = CGPoint(x: 0, y: containerHeight - (datePicker.frame.height + doneButton.frame.height + 36))
        
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
    @objc private func didTapDoneButton(_ sender: UIButton) {
        presenter?.inputs.didTapDone(with: datePicker.date)
    }
    
    @objc private func panGestureRecognizerAction(_ sender: UIPanGestureRecognizer) {
        guard let pointOrigin = pointOrigin else { return }
        
        let translation = sender.translation(in: view)
        
        let currentYPosition = pointOrigin.y + translation.y
        
        if currentYPosition >= pointOrigin.y - 100 {
            UIView.animate(withDuration: 1) {
                self.view.frame.origin = CGPoint(x: 0, y: currentYPosition)
            }
        }
        
        guard sender.state == .ended else { return }
        
        let dragVelocity = sender.velocity(in: view)
        
        if dragVelocity.y >= 20 {
            self.dismiss(animated: true, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin = pointOrigin
            }
        }
    }
    
    // MARK: - Configures
    private func configureDoneButton() {
        view.addSubview(doneButton)
        doneButton.anchor(top: view.topAnchor,
                          right: view.rightAnchor,
                          paddingTop: 18,
                          paddingRight: 18,
                          height: 20,
                          width: 60)
        
        doneButton.addTarget(self, action: #selector(didTapDoneButton(_:)), for: .touchUpInside)
    }
    
    private func configureDatePicker() {
        view.addSubview(datePicker)
        datePicker.anchor(top: doneButton.bottomAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor)
    }
    
    private func configurePanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
}

// MARK: - ReminderViewProtocol
extension ReminderController: ReminderViewProtocol {
    
}

extension ReminderController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
