//
//  TaskCell.swift
//  to-do-list
//
//  Created by vlsuv on 13.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "TaskCell"
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = Color.black
        label.textAlignment = .left
        return label
    }()
    
    func configure(_ task: Task) {
        titleLabel.text = task.title
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [titleLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        titleLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, bottom: contentView.bottomAnchor, paddingLeft: 18 * 2, paddingRight: 18)
    }
}
