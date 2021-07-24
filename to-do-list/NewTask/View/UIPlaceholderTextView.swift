//
//  UIPlaceholderTextView.swift
//  to-do-list
//
//  Created by vlsuv on 23.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class UIPlaceholderTextView: UITextView {
    
    // MARK: - Properties
    private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    // MARK: - Param
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    var placeholderColor: UIColor? {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    var placeholderFont: UIFont? {
        didSet {
            placeholderLabel.font = placeholderFont
        }
    }
    
    var attributedPlaceholder: NSAttributedString? {
        didSet {
            placeholderLabel.attributedText = attributedPlaceholder
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        placeholderLabel.anchor(top: topAnchor,
                                left: leftAnchor,
                                right: rightAnchor,
                                bottom: bottomAnchor,
                                paddingTop: textContainerInset.top,
                                paddingLeft: textContainerInset.left,
                                paddingRight: textContainerInset.right)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextView.textDidChangeNotification,
                                                  object: nil)
    }
    
    // MARK: - Handlers
    @objc func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
