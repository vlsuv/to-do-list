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
        label.font = .systemFont(ofSize: FontSize.title1, weight: .regular)
        label.textColor = Color.black
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageView?.image = Image.listBulletIcon?.withTintColor(Color.baseBlue)
        imageView?.tintColor = Color.baseBlue
        imageView?.contentMode = .scaleAspectFit
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Color.veryLightGray
        selectedBackgroundView = backgroundView
        
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
        [titleLabel]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        imageView?.anchor(left: contentView.leftAnchor,
                          paddingLeft: Space.mediumSpace,
                          height: Size.mediumIconHeight,
                          width: Size.mediumIconHeight)
        imageView?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        titleLabel.anchor(top: contentView.topAnchor,
                          left: imageView?.rightAnchor,
                          right: contentView.rightAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingLeft: Space.mediumSpace,
                          paddingRight: Space.mediumSpace)
    }
}
