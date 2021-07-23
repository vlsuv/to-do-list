//
//  TaskCell.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol TaskCellDelegate: class {
    func didTapDoneButton(cell: UITableViewCell)
}

class TaskCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "TaskCell"
    
    weak var delegate: TaskCellDelegate?
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = Color.mediumGray.cgColor
        button.setImage(Image.checkmarkIcon, for: .selected)
        button.tintColor = Color.baseBlue
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapDoneButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = Color.black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private var detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = Color.mediumGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        
        addSubviews()
        setupConstraints()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Color.veryLightGray
        selectedBackgroundView = backgroundView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ task: Task) {
        titleLabel.text = task.title
        titleLabel.alpha = task.isDone ? 0.6 : 1
        detailLabel.text = task.details
        
        doneButton.isSelected = task.isDone
        doneButton.layer.borderWidth = task.isDone ? 0 : 1.6
    }
    
    // MARK: - Targets
    @objc private func didTapDoneButton(_ sender: UIButton) {
        delegate?.didTapDoneButton(cell: self)
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [titleLabel, detailLabel, doneButton]
            .forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        let doneButtonSize: CGFloat = 20
        doneButton.anchor( top: contentView.topAnchor,
                           left: contentView.leftAnchor,
                           paddingTop: 8,
                           paddingLeft: 18,
                           height: doneButtonSize,
                           width: doneButtonSize)
        
        doneButton.layer.cornerRadius = doneButtonSize / 2
        
        titleLabel.anchor(top: contentView.topAnchor,
                          left: doneButton.rightAnchor,
                          right: contentView.rightAnchor,
                          paddingTop: 8,
                          paddingLeft: 8,
                          paddingRight: 18)
        
        detailLabel.anchor(top: titleLabel.bottomAnchor,
                           left: titleLabel.leftAnchor,
                           right: titleLabel.rightAnchor,
                           bottom: contentView.bottomAnchor,
                           paddingTop: 6,
                           paddingBottom: 8)
    }
}
