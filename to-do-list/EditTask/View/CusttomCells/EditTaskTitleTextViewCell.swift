//
//  EditTaskTitleTextViewCell.swift
//  to-do-list
//
//  Created by vlsuv on 24.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol EditTaskTitleTextViewCellDelegate: class {
    func didChangeText(cell: UITableViewCell, text: String)
}

class EditTaskTitleTextViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "EditTaskTitleTextViewCell"
    
    weak var delegate: EditTaskTitleTextViewCellDelegate?
    
    private var textView: UIPlaceholderTextView = {
        let textView = UIPlaceholderTextView()
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset.top = 0
        textView.isScrollEnabled = false
        
        textView.font = .systemFont(ofSize: 18, weight: .medium)
        textView.textColor = Color.black
        
        textView.placeholderFont = .systemFont(ofSize: 18, weight: .medium)
        textView.placeholderColor = Color.mediumGray
        return textView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textView.delegate = self
        
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: EditTaskTitleTextViewOption) {
        textView.text = model.text
        textView.placeholder = model.placeholder
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [textView]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        
        textView.anchor(top: contentView.topAnchor,
                        left: contentView.leftAnchor,
                        right: contentView.rightAnchor,
                        bottom: contentView.bottomAnchor,
                        paddingTop: 8,
                        paddingLeft: 18,
                        paddingRight: 18)
    }
}

// MARK: - UITextViewDelegate
extension EditTaskTitleTextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        
        delegate?.didChangeText(cell: self, text: text)
    }
}
