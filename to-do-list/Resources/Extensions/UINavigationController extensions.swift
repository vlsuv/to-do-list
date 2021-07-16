//
//  UINavigationController extensions.swift
//  to-do-list
//
//  Created by vlsuv on 15.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

extension UINavigationController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
