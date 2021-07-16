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
    
    private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New task"
        textField.textColor = Color.black
        return textField
    }()
    
    private var detailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add details"
        textField.textColor = Color.black
        textField.isHidden = true
        return textField
    }()
    
    private var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private var addDetailButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.listImage, for: .normal)
        return button
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(Color.black, for: .normal)
        return button
    }()
    
    // MARK: - Origin Point Properties
    private var hasSetPointOrigin = false
    
    private var pointOrigin: CGPoint?
    
    private var initialY: CGFloat?
    
    private var isKeyboardAppear: Bool = false
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureElements()
        addTargets()
        
        addKeyboardObservers()
        configurePanGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !isKeyboardAppear else { return }
        
        guard let containerHeight = presentationController?.containerView?.frame.height else {
            return
        }
        
        let elementsHeight: CGFloat = vStackView.frame.height + 36 + addDetailButton.frame.height
        
        view.frame.origin = CGPoint(x: 0, y: containerHeight - elementsHeight)
        
        initialY = containerHeight - elementsHeight
        
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
            
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
    
    @objc private func didChangeDetailTextFieldText(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        presenter?.inputs.didChangeDetailText(text)
    }
    
    @objc private func didTapSaveButton(_ sender: UITextField) {
        presenter?.inputs.didTapSave()
    }
    
    @objc private func didTapAddDetailButton(_ sender: UIButton) {
        guard detailTextField.isHidden else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.detailTextField.isHidden = false
            self.detailTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - Configures
    private func configureElements() {
        view.addSubview(vStackView)
        vStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          paddingTop: 18,
                          paddingLeft: 18,
                          paddingRight: 18,
                          height: 48)
        
        [titleTextField, detailTextField]
            .forEach { vStackView.addArrangedSubview($0) }
        
        view.addSubview(addDetailButton)
        addDetailButton.anchor(top: vStackView.bottomAnchor,
                               left: vStackView.leftAnchor,
                               paddingTop: 8,
                               height: 20)
        
        view.addSubview(saveButton)
        saveButton.anchor(top: vStackView.bottomAnchor,
                          right: view.rightAnchor,
                          paddingTop: 8,
                          paddingRight: 18,
                          height: 20,
                          width: 56)
    }
    
    private func addTargets() {
        titleTextField.addTarget(self, action: #selector(didChangeTitleTextFieldText(_:)), for: .editingChanged)
        detailTextField.addTarget(self, action: #selector(didChangeDetailTextFieldText(_:)), for: .editingChanged)
        addDetailButton.addTarget(self, action: #selector(didTapAddDetailButton(_:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSaveButton(_:)), for: .touchUpInside)
    }
    
    private func configurePanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        view.addGestureRecognizer(panGesture)
    }
}

// MARK: - NewTaskViewProtocol
extension NewTaskController: NewTaskViewProtocol {
    
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
        
        guard self.view.frame.origin.y == initialY else { return }
        
        UIView.animate(withDuration: duration) {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
        self.pointOrigin = self.view.frame.origin
        
        self.isKeyboardAppear = true
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: duration) {
            self.view.frame.origin.y += keyboardSize.height
        }
        
        self.pointOrigin = self.view.frame.origin
        
        self.isKeyboardAppear = false
    }
}

// MARK: Moving View
extension NewTaskController {
    @objc private func panGestureRecognizerAction(_ sender: UIPanGestureRecognizer) {
        guard let pointOrigin = pointOrigin else { return }
        
        let translation = sender.translation(in: view)
        let totalPointOrigin = pointOrigin.y + translation.y
        
        if totalPointOrigin >= pointOrigin.y - 100 {
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
                self.view.frame.origin = self.pointOrigin!
            }
        }
    }
}
