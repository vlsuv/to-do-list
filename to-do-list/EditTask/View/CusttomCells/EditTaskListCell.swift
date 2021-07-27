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
        let imageView = UIImageView()
        imageView.image = Image.chevronDownTwoIcon.withTintColor(Color.baseBlue)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Color.baseBlue
        return imageView
    }()
    
    private var listTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = Color.baseBlue
        return label
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
    
    // MARK: - Configures
    func configure(_ model: EditTaskListOption) {
        listTitleLabel.text = model.parentList()?.title
    }
    
    private func addSubviews() {
        [listTitleLabel, selectIconImageView]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        listTitleLabel.anchor(top: contentView.topAnchor,
                              left: contentView.leftAnchor,
                              bottom: contentView.bottomAnchor,
                              paddingLeft: 18)
        listTitleLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -18).isActive = true
        
        selectIconImageView.anchor(left: listTitleLabel.rightAnchor,
                                   paddingLeft: 8,
                                   height: 10,
                                   width: 10)
        selectIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
