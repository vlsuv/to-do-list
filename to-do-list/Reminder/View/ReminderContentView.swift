//
//  ReminderContentView.swift
//  to-do-list
//
//  Created by vlsuv on 24.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class ReminderContentView: UIView {
    
    // MARK: - Elements
    var doneButton: UIButton = {
        let button = UIButton()
        let normalAttributedString = NSAttributedString(string: "Done", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize.title2, weight: .medium),
            NSAttributedString.Key.foregroundColor: Color.baseBlue
        ])
        button.setAttributedTitle(normalAttributedString, for: .normal)
        return button
    }()
    
    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        return datePicker
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
        [doneButton, datePicker]
            .forEach { self.addSubview($0) }
    }
    
    private func configureConstraints() {
        doneButton.anchor(top: self.topAnchor,
                          right: self.rightAnchor,
                          paddingTop: Space.mediumSpace,
                          paddingRight: Space.mediumSpace,
                          height: 20,
                          width: 48)
        
        datePicker.anchor(top: doneButton.bottomAnchor,
                          left: self.leftAnchor,
                          right: self.rightAnchor,
                          paddingTop: Space.mediumSpace,
                          paddingLeft: Space.mediumSpace,
                          paddingRight: Space.mediumSpace)
    }
}
