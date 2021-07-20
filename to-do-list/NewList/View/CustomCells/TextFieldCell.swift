//
//  TextFieldCell.swift
//  to-do-list
//
//  Created by vlsuv on 14.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate: class {
    func didChangeText(cell: TextFieldCell, textField: UITextField)
}

class TextFieldCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "TextFieldCell"
    
    weak var delegate: TextFieldCellDelegate?
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 18, weight: .regular)
        textField.textColor = Color.black
        textField.textAlignment = .left
        textField.autocapitalizationType = .none
        return textField
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        configureConstraints()
        configureTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: TextFieldCellOption) {
        textField.text = model.text
        textField.placeholder = model.placeholder
        
        textField.becomeFirstResponder()
    }
    
    // MARK: - Targets
    @objc private func didChangeTextFieldValue(_ sender: UITextField) {
        delegate?.didChangeText(cell: self, textField: sender)
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [textField]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        textField.anchor(top: contentView.topAnchor,
                         left: contentView.leftAnchor,
                         right: contentView.rightAnchor,
                         bottom: contentView.bottomAnchor,
                         paddingLeft: 18,
                         paddingRight: 18)
    }
    
    private func configureTargets() {
        textField.addTarget(self, action: #selector(didChangeTextFieldValue(_:)), for: .editingChanged)
    }
}
