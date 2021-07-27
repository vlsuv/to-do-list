//
//  ListChoiseCell.swift
//  to-do-list
//
//  Created by vlsuv on 27.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class ListChoiseCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "ListChoiseCell"
    
    private var listTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private var selectImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imageView.contentMode = .scaleAspectFit
        imageView.image = Image.checkmarkIcon?.withTintColor(Color.darkGray)
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureConstraints()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Color.veryLightGray
        selectedBackgroundView = backgroundView
        
        accessoryView = selectImageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ list: ListModel, owner: Bool) {
        listTitleLabel.text = list.title
        selectImageView.isHidden = !owner
    }
    
    // MARK: - Configures
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
