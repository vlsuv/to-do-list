//
//  EditTaskListCell.swift
//  to-do-list
//
//  Created by vlsuv on 24.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class EditTaskListCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "EditTaskListCell"
    
    private var selectIconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imageView.image = Image.chevronDown
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Color.mediumGray
        return imageView
    }()
    
    private var listTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = Color.mediumGray
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        configureConstraints()
        
        accessoryView = selectIconImageView
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    func configure(_ model: EditTaskListOption) {
        listTitleLabel.text = model.parentList()?.title
    }
    
    private func addSubviews() {
        [listTitleLabel]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        listTitleLabel.anchor(top: contentView.topAnchor,
                              left: contentView.leftAnchor,
                              right: contentView.rightAnchor,
                              bottom: contentView.bottomAnchor,
                              paddingLeft: 18,
                              paddingRight: 18)
    }
}
