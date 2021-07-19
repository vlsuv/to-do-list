//
//  EditTaskTextViewCell.swift
//  to-do-list
//
//  Created by vlsuv on 18.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol EditTaskTextViewCellDelegate: class {
    func didChangeText(cell: EditTaskTextViewCell, text: String)
}

class EditTaskTextViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "EditTaskTextViewCell"
    
    weak var delegate: EditTaskTextViewCellDelegate?
    
    var textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        return textView
    }()
    
    func configure(_ model: EditTaskTextViewOption) {
        textView.text = model.text
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureConstraints()
        
        textView.delegate = self
        
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [textView].forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        textView.anchor(top: contentView.topAnchor,
                        left: contentView.leftAnchor,
                        right: contentView.rightAnchor,
                        bottom: contentView.bottomAnchor,
                        paddingLeft: 18,
                        paddingRight: 18)
    }
}

// MARK: - UITextViewDelegate
extension EditTaskTextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        
        delegate?.didChangeText(cell: self, text: text)
    }
}
