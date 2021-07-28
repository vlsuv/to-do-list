//
//  ListDetailStaticCell.swift
//  to-do-list
//
//  Created by vlsuv on 27.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class ListDetailStaticCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "ListDetailStaticCell"
    
    private var listDetailTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: FontSize.body, weight: .regular)
        label.textColor = Color.black
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureConstraints()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Color.veryLightGray
        selectedBackgroundView = backgroundView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: ListMoreDetailStaticCellOption) {
        listDetailTitleLabel.text = model.title
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [listDetailTitleLabel]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        listDetailTitleLabel.anchor(top: contentView.topAnchor,
                                    left: contentView.leftAnchor,
                                    right: contentView.rightAnchor,
                                    bottom: contentView.bottomAnchor,
                                    paddingLeft: Space.mediumSpace,
                                    paddingRight: Space.mediumSpace)
    }
}
