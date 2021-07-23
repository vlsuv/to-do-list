//
//  ReminderButton.swift
//  to-do-list
//
//  Created by vlsuv on 22.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol ReminderButtonDelegate: class {
    func didTapCancel(button: UIButton)
}

class ReminderButton: UIButton {
    
    // MARK: - Properties
    weak var delegate: ReminderButtonDelegate?
    
    private var dateTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = Color.mediumGray
        label.textAlignment = .center
        return label
    }()
    
    private var cancelIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = Color.mediumGray
        imageView.image = Image.xMarkIcon
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let buttonHeight: CGFloat = 32
        self.clipsToBounds = true
        self.layer.cornerRadius = buttonHeight / 2
        self.layer.borderColor = Color.lightGray.cgColor
        self.layer.borderWidth = 1
        self.anchor(height: buttonHeight,
                    width: 160)
        
        addSubviews()
        configureConstraints()
        configureTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        dateTitle.text = text
    }
    
    // MARK: - Targets
    @objc private func didTapIcon() {
        delegate?.didTapCancel(button: self)
    }
    
    // MARK: - Configures
    private func addSubviews() {
        addSubview(dateTitle)
        addSubview(cancelIconImageView)
    }
    
    private func configureConstraints() {
        let cancelIconSize: CGFloat = 15
        cancelIconImageView.anchor(right: rightAnchor,
                                   paddingRight: 5,
                                   height: cancelIconSize,
                                   width: cancelIconSize)
        cancelIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        dateTitle.anchor(top: topAnchor,
                         left: leftAnchor,
                         right: cancelIconImageView.leftAnchor,
                         bottom: bottomAnchor,
                         paddingLeft: 5,
                         paddingRight: 5)
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIcon))
        cancelIconImageView.addGestureRecognizer(tapGesture)
    }
}
