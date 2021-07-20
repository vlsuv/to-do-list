//
//  EditTaskReminderCell.swift
//  to-do-list
//
//  Created by vlsuv on 20.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol EditTaskReminderCellDelegate: class {
    func didTapReminderButton(cell: EditTaskReminderCell)
}

class EditTaskReminderCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "EditTaskReminderCell"
    
    weak var delegate: EditTaskReminderCellDelegate?
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        return label
    }()
    
    private var reminderButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Color.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = Color.black.cgColor
        button.layer.cornerRadius = 22
        return button
    }()
    
    func configure(_ model: EditTaskReminderOption) {
        guard let reminder = model.reminder else {
            reminderButton.isHidden = true
            titleLabel.isHidden = false
            titleLabel.text = model.placeholder
            return
        }
        
        reminderButton.isHidden = false
        titleLabel.isHidden = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        let dateString = dateFormatter.string(from: reminder.date)
        
        reminderButton.setTitle(dateString, for: .normal)
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureConstraints()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Targets
    @objc private func didTapReminderButton(_ sender: UIButton) {
        delegate?.didTapReminderButton(cell: self)
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [titleLabel, reminderButton]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        titleLabel.anchor(top: contentView.topAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingLeft: 18,
                          paddingRight: 18)
        
        reminderButton.anchor(top: contentView.topAnchor,
                              left: contentView.leftAnchor,
                              bottom: contentView.bottomAnchor,
                              paddingLeft: 18)
    }
    
    private func addTargets() {
        reminderButton.addTarget(self, action: #selector(didTapReminderButton(_:)), for: .touchUpInside)
    }
}
