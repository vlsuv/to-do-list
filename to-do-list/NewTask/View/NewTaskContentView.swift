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
        textField.font = .systemFont(ofSize: FontSize.title2, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(string: "New task", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize.title2, weight: .regular),
            NSAttributedString.Key.foregroundColor: Color.mediumGray
        ])
        return textField
    }()
    
    var detailTextView: UIPlaceholderTextView = {
        let textView = UIPlaceholderTextView()
        textView.font = .systemFont(ofSize: FontSize.body, weight: .regular)
        textView.textColor = Color.mediumGray
        textView.textContainer.lineFragmentPadding = 0
        
        textView.isScrollEnabled = false
        textView.isHidden = true
        
        textView.attributedPlaceholder = NSAttributedString(string: "Add details", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize.body, weight: .regular),
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
        button.setImage(Image.listImage?.withTintColor(Color.baseBlue), for: .normal)
        button.tintColor = Color.baseBlue
        return button
    }()
    
    var addReminderButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.calendarIcon?.withTintColor(Color.baseBlue), for: .normal)
        button.tintColor = Color.baseBlue
        return button
    }()
    
    var saveButton: UIButton = {
        let button = UIButton()
        let normalAttributedString = NSAttributedString(string: "Save", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize.title2, weight: .medium),
            NSAttributedString.Key.foregroundColor: Color.baseBlue
        ])
        button.setAttributedTitle(normalAttributedString, for: .normal)
        return button
    }()
    
    // MARK: - StackViews
    var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Space.smallSpace
        stackView.alignment = .leading
        return stackView
    }()
    
    var hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Space.mediumSpace
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
                          paddingTop: Space.mediumSpace,
                          paddingLeft: Space.mediumSpace,
                          paddingRight: Space.mediumSpace)
        
        detailTextView.anchor(left: vStackView.leftAnchor, right: vStackView.rightAnchor)
        
        saveButton.anchor(top: vStackView.bottomAnchor,
                          right: self.rightAnchor,
                          paddingTop: Space.mediumSpace,
                          paddingRight: Space.mediumSpace,
                          height: Size.mediumIconHeight)
        
        [addDetailButton, addReminderButton]
            .forEach { hStackView.addArrangedSubview($0) }
        hStackView.anchor(top: vStackView.bottomAnchor,
                          left: self.leftAnchor,
                          paddingTop: Space.mediumSpace,
                          paddingLeft: Space.mediumSpace)
        
        hStackView.rightAnchor.constraint(lessThanOrEqualTo: saveButton.leftAnchor, constant: -Space.mediumSpace).isActive = true
    }
}
