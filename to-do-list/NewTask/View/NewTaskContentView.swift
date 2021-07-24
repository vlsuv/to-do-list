//
//  NewTaskContentView.swift
//  to-do-list
//
//  Created by vlsuv on 24.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class NewTaskContentView: UIView {
    
    // MARK: - Elements
    var titleTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = Color.black
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(string: "New task", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular),
            NSAttributedString.Key.foregroundColor: Color.mediumGray
        ])
        return textField
    }()
    
    var detailTextView: UIPlaceholderTextView = {
        let textView = UIPlaceholderTextView()
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.textColor = Color.mediumGray
        textView.textContainer.lineFragmentPadding = 0
        
        textView.isScrollEnabled = false
        textView.isHidden = true
        
        textView.attributedPlaceholder = NSAttributedString(string: "Add details", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
            NSAttributedString.Key.foregroundColor: Color.mediumGray
        ])
        return textView
    }()
    
    var reminderButton: ReminderButton = {
        let button = ReminderButton()
        button.isHidden = true
        return button
    }()
    
    var addDetailButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.listImage, for: .normal)
        button.tintColor = Color.baseBlue
        return button
    }()
    
    var addReminderButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.calendarIcon, for: .normal)
        button.tintColor = Color.baseBlue
        return button
    }()
    
    var saveButton: UIButton = {
        let button = UIButton()
        let normalAttributedString = NSAttributedString(string: "Save", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: Color.baseBlue
        ])
        button.setAttributedTitle(normalAttributedString, for: .normal)
        return button
    }()
    
    // MARK: - StackViews
    var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    var hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 18
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.white
        
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        superview?.setNeedsLayout()
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [vStackView, hStackView, saveButton]
            .forEach { self.addSubview($0) }
    }
    
    private func configureConstraints() {
        [titleTextField, detailTextView, reminderButton]
            .forEach { vStackView.addArrangedSubview($0) }
        vStackView.anchor(top: self.safeAreaLayoutGuide.topAnchor,
                          left: self.leftAnchor,
                          right: self.rightAnchor,
                          paddingTop: 18,
                          paddingLeft: 18,
                          paddingRight: 18)
        
        detailTextView.anchor(left: vStackView.leftAnchor, right: vStackView.rightAnchor)
        
        saveButton.anchor(top: vStackView.bottomAnchor,
                          right: self.rightAnchor,
                          paddingTop: 18,
                          paddingRight: 18,
                          height: 20)
        
        [addDetailButton, addReminderButton]
            .forEach { hStackView.addArrangedSubview($0) }
        hStackView.anchor(top: vStackView.bottomAnchor,
                          left: self.leftAnchor,
                          paddingTop: 18,
                          paddingLeft: 18)
        
        hStackView.rightAnchor.constraint(lessThanOrEqualTo: saveButton.leftAnchor, constant: -18).isActive = true
    }
}
