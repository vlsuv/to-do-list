//
//  NewTaskController.swift
//  to-do-list
//
//  Created by vlsuv on 15.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class NewTaskController: UIViewController {
    
    // MARK: - Properties
    var presenter: NewTaskPresenterType?
    
    private var contentView: NewTaskContentView = {
        let view = NewTaskContentView()
        return view
    }()
    
    private var isFirstLayout: Bool = true
    
    // MARK: - Size Properties
    private var containerHeight: CGFloat {
        return presentationController?.containerView?.frame.height ?? 0
    }
    
    private var elementsHeight: CGFloat {
        return contentView.vStackView.frame.height + contentView.hStackView.frame.height + 54
    }
    
    private var keyboardHeight: CGFloat?
    
    private var currentPointOrigin: CGPoint {
        return CGPoint(x: 0, y: containerHeight - (elementsHeight + (keyboardHeight ?? 0)))
    }
    
    private var initialYPoint: CGFloat {
        return containerHeight - elementsHeight
    }
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        addTargets()
        addKeyboardObservers()
        configureMovePanGestureRecognizer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.frame.origin = currentPointOrigin
        
        if isFirstLayout {
            isFirstLayout = false
            
            contentView.titleTextField.becomeFirstResponder()
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
    @objc private func didTapAddDetailButton(_ sender: UIButton) {
        guard contentView.detailTextView.isHidden else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.contentView.detailTextView.isHidden = false
            self.contentView.detailTextView.becomeFirstResponder()
        }
    }
    
    @objc private func didTapAddReminderButton(_ sender: UIButton) {
        view.endEditing(true)
        
        presenter?.inputs.didTapAddReminder()
    }
    
    @objc private func didTapSaveButton(_ sender: UITextField) {
        presenter?.inputs.didTapSave()
    }
    
    @objc private func didChangeTitleTextFieldText(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        presenter?.inputs.didChangeTitleText(text)
    }
    
    @objc private func didTapReminderButton(_ sender: UIButton) {
        presenter?.inputs.didTapReminderButton()
    }
    
    // MARK: - Configures
    private func configureContentView() {
        view.addSubview(contentView)
        contentView.frame = view.bounds
        
        contentView.reminderButton.delegate = self
        contentView.detailTextView.delegate = self
    }
    
    private func addTargets() {
        contentView.titleTextField.addTarget(self, action: #selector(didChangeTitleTextFieldText(_:)), for: .editingChanged)
        contentView.addDetailButton.addTarget(self, action: #selector(didTapAddDetailButton(_:)), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(didTapSaveButton(_:)), for: .touchUpInside)
        contentView.addReminderButton.addTarget(self, action: #selector(didTapAddReminderButton(_:)), for: .touchUpInside)
        contentView.reminderButton.addTarget(self, action: #selector(didTapReminderButton(_:)), for: .touchUpInside)
    }
}

// MARK: - NewTaskViewProtocol
extension NewTaskController: NewTaskViewProtocol {
    func updateReminderLabel(with stringDate: String?) {
        if let stringDate = stringDate {
            contentView.reminderButton.isHidden = false
            contentView.reminderButton.configure(text: stringDate)
        } else {
            contentView.reminderButton.isHidden = true
            contentView.reminderButton.setTitle("", for: .normal)
        }
    }
}

// MARK: - UITextViewDelegate
extension NewTaskController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == contentView.detailTextView {
            guard let text = textView.text else { return }
            
            presenter?.inputs.didChangeDetailText(text)
        }
    }
}

// MARK: - ReminderButtonDelegate
extension NewTaskController: ReminderButtonDelegate {
    func didTapCancel(button: UIButton) {
        if button == contentView.reminderButton {
            presenter?.inputs.didTapCancelReminder()
        }
    }
}

// MARK: - View Moving
extension NewTaskController {
    private func configureMovePanGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func panGestureRecognizerAction(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        let totalPointOrigin = currentPointOrigin.y + translation.y
        
        if totalPointOrigin >= currentPointOrigin.y - (elementsHeight / 2) {
            UIView.animate(withDuration: 1) {
                self.view.frame.origin = CGPoint(x: 0, y: totalPointOrigin)
            }
        }
        
        guard sender.state == .ended else { return }
        
        let dragVelocity = sender.velocity(in: view)
        
        if dragVelocity.y >= 1300 {
            self.dismiss(animated: true, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin = (self.currentPointOrigin)
            }
        }
    }
}

// MARK: - Keyboard Observers
extension NewTaskController {
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        guard view.frame.origin.y == initialYPoint else { return }
        
        self.keyboardHeight = keyboardSize.height
        
        UIView.animate(withDuration: duration) {
            self.view.frame.origin = self.currentPointOrigin
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        self.keyboardHeight = nil
        
        UIView.animate(withDuration: duration) {
            self.view.frame.origin = self.currentPointOrigin
        }
    }
}
