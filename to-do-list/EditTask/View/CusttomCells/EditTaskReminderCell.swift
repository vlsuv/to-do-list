//
//  EditTaskReminderCell.swift
//  to-do-list
//
//  Created by vlsuv on 20.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol EditTaskReminderCellDelegate: class {
    func didTapReminderButton(cell: UITableViewCell)
    func didTapCancelReminderButton(cell: UITableViewCell)
}

class EditTaskReminderCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "EditTaskReminderCell"
    
    weak var delegate: EditTaskReminderCellDelegate?
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.mediumGray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var reminderButton: ReminderButton = {
        let button = ReminderButton()
        button.delegate = self
        return button
    }()
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubviews()
        configureConstraints()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: EditTaskReminderOption) {
        imageView?.image = Image.calendarIcon
        imageView?.tintColor = Color.mediumGray
        imageView?.contentMode = .scaleAspectFit
        
        titleLabel.text = model.placeholder
        
        if let reminder = model.reminder() {
            reminderButton.isHidden = false
            titleLabel.isHidden = true
            
            reminderButton.configure(text: dateFormatter.string(from: reminder.date))
        } else {
            reminderButton.isHidden = true
            titleLabel.isHidden = false
        }
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
        let imageViewSize: CGFloat = 20
        let topPadding: CGFloat = (contentView.frame.height - imageViewSize) / 2
        
        imageView?.anchor(top: topAnchor,
                          left: leftAnchor,
                          paddingTop: topPadding,
                          paddingLeft: 18,
                          height: imageViewSize,
                          width: imageViewSize)
        
        titleLabel.anchor(top: contentView.topAnchor,
                          left: imageView?.rightAnchor,
                          right: contentView.rightAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingLeft: 18,
                          paddingRight: 18)
        
        reminderButton.anchor(left: imageView?.rightAnchor,
                              paddingLeft: 18)
        reminderButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    private func addTargets() {
        reminderButton.addTarget(self, action: #selector(didTapReminderButton(_:)), for: .touchUpInside)
    }
}

// MARK: - ReminderButtonDelegate
extension EditTaskReminderCell: ReminderButtonDelegate {
    func didTapCancel(button: UIButton) {
        delegate?.didTapCancelReminderButton(cell: self)
    }
}
