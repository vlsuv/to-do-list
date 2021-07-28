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
    
    private var textView: UIPlaceholderTextView = {
        let textView = UIPlaceholderTextView()
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset.top = 0
        textView.isScrollEnabled = false
        
        textView.font = .systemFont(ofSize: FontSize.title2, weight: .regular)
        textView.textColor = Color.black
        
        textView.placeholderFont = .systemFont(ofSize: FontSize.title2, weight: .medium)
        textView.placeholderColor = Color.darkGray
        return textView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textView.delegate = self
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: EditTaskTextViewOption) {
        imageView?.image = model.icon?.withTintColor(Color.darkGray)
        imageView?.tintColor = Color.darkGray
        imageView?.contentMode = .scaleAspectFit
        
        textView.text = model.text?()
        textView.placeholder = model.placeholder
        
        updateElementsConstraints()
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [textView]
            .forEach { contentView.addSubview($0) }
    }
    
    private func updateElementsConstraints() {
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: Size.mediumCellHeight).isActive = true
        
        let imageViewSize: CGFloat = Size.mediumIconHeight
        let topPadding: CGFloat = (contentView.frame.height - imageViewSize) / 2
        
        imageView?.anchor(top: topAnchor,
                          left: leftAnchor,
                          paddingTop: topPadding,
                          paddingLeft: Space.mediumSpace,
                          height: imageViewSize,
                          width: imageViewSize)
        
        textView.anchor(top: contentView.topAnchor,
                        left: imageView?.image == nil ? contentView.leftAnchor : imageView?.rightAnchor,
                        right: contentView.rightAnchor,
                        bottom: contentView.bottomAnchor,
                        paddingTop: topPadding,
                        paddingLeft: Space.mediumSpace,
                        paddingRight: Space.mediumSpace)
    }
}

// MARK: - UITextViewDelegate
extension EditTaskTextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        
        delegate?.didChangeText(cell: self, text: text)
    }
}
