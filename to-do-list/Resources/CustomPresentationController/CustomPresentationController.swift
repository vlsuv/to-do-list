//
//  CustomPresentationController.swift
//  to-do-list
//
//  Created by vlsuv on 15.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class CustomPresentationController: UIPresentationController {
    
    // MARK: - Properties
    private let blurEffectView: UIVisualEffectView!
    
    private var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    // MARK: - Init
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
        
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
    }
    
    // MARK: - Configures
    override var frameOfPresentedViewInContainerView: CGRect {
        
        return CGRect(origin: CGPoint(x: 0, y: 0),
                      size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height))
    }
    
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { UIViewControllerTransitionCoordinatorContext in
            
            self.blurEffectView.alpha = 0.5
        }, completion: { UIViewControllerTransitionCoordinatorContext in
            
        })
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { UIViewControllerTransitionCoordinatorContext in
            
            self.blurEffectView.alpha = 0
        }, completion: { UIViewControllerTransitionCoordinatorContext in
            
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.roundCorners([.topLeft, .topRight], radius: 12)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        
        blurEffectView.frame = containerView!.bounds
    }
    
    @objc func dismissController(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
