//
//  UIViewController+Presentation.swift
//  SwiftDialog
//
//  Created by iOS on 2020/2/5.
//  Copyright © 2020 iOS. All rights reserved.
//


import Foundation
import UIKit
/// 遵守PresentationViewType协议的UIViewController
public typealias PresentationViewController = UIViewController & PresentedViewType

extension UIViewController {
    
    /// 自定义present方法
    public func presentViewController(_ viewController: PresentationViewController, animated: Bool = true) {
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        present(viewController, animated: animated, completion: nil)
    }
    
}

// MARK: -  UIViewControllerTransitioningDelegate
extension UIViewController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let presentedVC = presented as? PresentedViewType else { return nil }
        return presentedVC.presentTransitionType.animation
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let dismissedVC = dismissed as? PresentedViewType else { return nil }
        return dismissedVC.dismissTransitionType.animation
    }
    
}
