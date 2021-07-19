//
//  EditTaskTextFieldCell.swift
//  to-do-list
//
//  Created by vlsuv on 18.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol EditTaskTextFieldCellDelegate: class {
    func didChangeTextFieldText(cell: EditTaskTextFieldCell, text: String)
}

class EditTaskTextFieldCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "EditTaskTextFieldCell"
    
    weak var delegate: EditTaskTextFieldCellDelegate?
    
    var textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    func configure(_ model: EditTaskTextFieldOption) {
        textField.text = model.text
        textField.placeholder = model.placeholder
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureConstraints()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Targets
    @objc private func didChangeTextFieldText(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        delegate?.didChangeTextFieldText(cell: self, text: text)
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [textField].forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        textField.anchor(top: contentView.topAnchor,
                         left: contentView.leftAnchor,
                         right: contentView.rightAnchor,
                         bottom: contentView.bottomAnchor,
                         paddingLeft: 18,
                         paddingRight: 18)
    }
    
    private func addTargets() {
        textField.addTarget(self, action: #selector(didChangeTextFieldText(_:)), for: .editingChanged)
    }
}
