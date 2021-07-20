//
//  ListCell.swift
//  to-do-list
//
//  Created by vlsuv on 20.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "ListCell"
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = Color.black
        return label
    }()
    
    private var listIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.listBulletIcon
        imageView.tintColor = Color.baseBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ list: ListModel) {
        titleLabel.text = list.title
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [listIcon, titleLabel]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        listIcon.anchor(left: contentView.leftAnchor,
                        paddingLeft: 18,
                        height: 20,
                        width: 20)
        listIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        titleLabel.anchor(top: contentView.topAnchor,
                          left: listIcon.rightAnchor,
                          right: contentView.rightAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingLeft: 8,
                          paddingRight: 18)
    }
}
