//
//  TasksSectionCell.swift
//  to-do-list
//
//  Created by vlsuv on 21.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class TasksSectionCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "TasksSectionCell"
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.font = .systemFont(ofSize: FontSize.title2, weight: .medium)
        return label
    }()
    
    private var stateImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Size.smallIconSize, height: Size.smallIconSize))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Color.mediumGray
        return imageView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureConstraints()
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: TasksSection) {
        titleLabel.text = "\(model.title) (\(model.tasks.count))"
        stateImageView.image = model.isExpand ? Image.chevronUp : Image.chevronDown
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [titleLabel]
            .forEach { contentView.addSubview($0) }
        
        accessoryView = stateImageView
    }
    
    private func configureConstraints() {
        titleLabel.anchor(top: contentView.topAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingLeft: Space.mediumSpace,
                          paddingRight: Space.mediumSpace)
    }
}
