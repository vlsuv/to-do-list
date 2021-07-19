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
    
    var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New task"
        textField.textColor = Color.black
        return textField
    }()
    
    var detailTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isHidden = true
        textView.textContainer.maximumNumberOfLines = 5
        return textView
    }()
    
    var reminderButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitleColor(Color.black, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    var addDetailButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(Image.listImage, for: .normal)
        return button
    }()
    
    var addReminderButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(Image.calendarIcon, for: .normal)
        return button
    }()
    
    var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(Color.black, for: .normal)
        return button
    }()
    
    var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    var hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    // Size Properties
    private var keyboardHeight: CGFloat?
    
    var containerHeight: CGFloat {
        return presentationController?.containerView?.frame.height ?? 0
    }
    
    var elementsHeight: CGFloat {
        return vStackView.frame.height + hStackView.frame.height + 36
    }
    
    var currentPointOrigin: CGPoint {
        return CGPoint(x: 0, y: containerHeight - (elementsHeight + (keyboardHeight ?? 0)))
    }
    
    private var initialYPoint: CGFloat {
        return containerHeight - elementsHeight
    }
    
    private var isFirstLayout: Bool = true
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureElements()
        addTargets()
        
        addKeyboardObservers()
        configurePanGesture()
        
        detailTextView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.frame.origin = currentPointOrigin
        
        if isFirstLayout {
            isFirstLayout = false
            
            titleTextField.becomeFirstResponder()
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
    @objc private func didChangeTitleTextFieldText(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        presenter?.inputs.didChangeTitleText(text)
    }
    
    @objc private func didTapSaveButton(_ sender: UITextField) {
        presenter?.inputs.didTapSave()
    }
    
    @objc private func didTapAddDetailButton(_ sender: UIButton) {
        guard detailTextView.isHidden else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.detailTextView.isHidden = false
            self.detailTextView.becomeFirstResponder()
        }
    }
    
    @objc private func didTapAddReminderButton(_ sender: UIButton) {
        view.endEditing(true)
        
        presenter?.inputs.didTapAddReminder()
    }
    
    @objc private func didTapReminderButton(_ sender: UIButton) {
        presenter?.inputs.didTapReminderButton()
    }
    
    // MARK: - Configures
    private func configureElements() {
        view.addSubview(vStackView)
        vStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          paddingTop: 18,
                          paddingLeft: 18,
                          paddingRight: 18)
        
        [titleTextField, detailTextView, reminderButton]
            .forEach { vStackView.addArrangedSubview($0) }
        
        view.addSubview(saveButton)
        saveButton.anchor(top: vStackView.bottomAnchor,
                          right: view.rightAnchor,
                          paddingTop: 8,
                          paddingRight: 18,
                          height: 20,
                          width: 56)
        
        view.addSubview(hStackView)
        hStackView.anchor(top: vStackView.bottomAnchor,
                          left: view.leftAnchor,
                          paddingTop: 8,
                          paddingLeft: 18,
                          height: 20)
        
        [addDetailButton, addReminderButton]
            .forEach { hStackView.addArrangedSubview($0) }
    }
    
    private func addTargets() {
        titleTextField.addTarget(self, action: #selector(didChangeTitleTextFieldText(_:)), for: .editingChanged)
        addDetailButton.addTarget(self, action: #selector(didTapAddDetailButton(_:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSaveButton(_:)), for: .touchUpInside)
        addReminderButton.addTarget(self, action: #selector(didTapAddReminderButton(_:)), for: .touchUpInside)
        reminderButton.addTarget(self, action: #selector(didTapReminderButton(_:)), for: .touchUpInside)
    }
    
    private func configurePanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        view.addGestureRecognizer(panGesture)
    }
}

// MARK: - NewTaskViewProtocol
extension NewTaskController: NewTaskViewProtocol {
    func updateReminderLabel(with stringDate: String?) {
        guard let stringDate = stringDate else {
            reminderButton.isHidden = true
            reminderButton.setTitle("", for: .normal)
            return
        }
        
        reminderButton.isHidden = false
        reminderButton.setTitle(stringDate, for: .normal)
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

// MARK: Moving View
extension NewTaskController {
    @objc private func panGestureRecognizerAction(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let totalPointOrigin = currentPointOrigin.y + translation.y
        
        if totalPointOrigin >= currentPointOrigin.y - 100 {
            UIView.animate(withDuration: 1) {
                self.view.frame.origin = CGPoint(x: 0, y: totalPointOrigin)
            }
        }
        
        guard sender.state == .ended else { return }
        
        let dragVelocity = sender.velocity(in: view)
        
        if dragVelocity.y >= 20 {
            self.dismiss(animated: true, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin = (self.currentPointOrigin)
            }
        }
    }
}

// MARK: - UITextViewDelegate
extension NewTaskController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == detailTextView {
            guard let text = textView.text else { return }
            
            presenter?.inputs.didChangeDetailText(text)
        }
    }
}
