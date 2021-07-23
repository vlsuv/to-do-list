//
//  UINavigationController extensions.swift
//  to-do-list
//
//  Created by vlsuv on 15.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

extension UINavigationController {
    func toTransparent() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
}
