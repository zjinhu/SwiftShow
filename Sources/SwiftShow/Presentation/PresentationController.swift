//
//  PresentationController.swift
//  SwiftDialog
//
//  Created by iOS on 2020/2/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIPresentationController subclass, overrides presentation-related properties and methods
// MARK: - UIPresentationController子类，重写present相关属性和方法
public final class PresentationController: UIPresentationController {
    
    /// Presentation configuration / present配置
    private let component: PresentedViewComponent
    
    /// Background overlay / 背景蒙层
    private lazy var backgroundView: UIView = {
        let containerbounds = containerView?.bounds ?? UIScreen.main.bounds
        let backgroundView = UIView(frame: containerbounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        backgroundView.alpha = 0.0
        if component.canTapBGDismiss {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTapped))
            backgroundView.addGestureRecognizer(tapGesture)
        }
        return backgroundView
    }()
    
    /// Pan gesture starting point / pan的起始点
    private var panStart: CGPoint = .zero
    
    /// Pan gesture direction / pan手势方向
    private var panDirection: PanDismissDirection {
        return component.panDismissDirection ?? component.destination.panDirection
    }
    
    /// Current input view / 当前输入view
    private var textInputView: UIView?
    
    /// Keyboard frame / 键盘frame
    private var keyboardFrame: CGRect?
    
    /// Keyboard animation duration / 键盘动画时间
    private var keyboardAnimationDuration: TimeInterval?
    
    // MARK: - override
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        component = (presentedViewController as? PresentedViewType)?.presentedViewComponent ?? PresentedViewComponent(contentSize: CGSize(width: 240, height: 200))
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    /// Returns the frame of the presented view in the container / 返回被展示视图在容器中的frame
    public override var frameOfPresentedViewInContainerView: CGRect {
        let containerbounds = containerView?.bounds ?? UIScreen.main.bounds
        let containerWidth = containerbounds.width
        let containerHeight = containerbounds.height
        let contentSize = component.contentSize
        switch component.destination {
        case .center:
            return CGRect(x: (containerWidth - contentSize.width) / 2, y: (containerHeight - contentSize.height) / 2, width: contentSize.width, height: contentSize.height)
        case .bottomBaseline:
            return CGRect(x: (containerWidth - contentSize.width) / 2, y: containerHeight - contentSize.height, width: contentSize.width, height: contentSize.height)
        case .leftBaseline:
            return CGRect(x: 0, y: (containerHeight - contentSize.height) / 2, width: contentSize.width, height: contentSize.height)
        case .rightBaseline:
            return CGRect(x: containerWidth - contentSize.width, y: (containerHeight - contentSize.height) / 2, width: contentSize.width, height: contentSize.height)
        case .topBaseline:
            return CGRect(x: (containerWidth - contentSize.width) / 2, y: 0, width: contentSize.width, height: contentSize.height)
        case .custom(let center):
            return CGRect(x: center.x - contentSize.width / 2, y: center.y - contentSize.height / 2, width: contentSize.width, height: contentSize.height)
        }
    }
    
    /// Add background view before presentation / 将要弹出时添加背景按钮
    public override func presentationTransitionWillBegin() {
        /// Register keyboard notifications / 注册键盘通知
        registerObservers()
        /// Background animation / 背景动画
        guard let containerView = containerView else { return }
        containerView.addSubview(backgroundView)
        guard let coordinator = presentedViewController.transitionCoordinator else {
            backgroundView.alpha = 1.0
            return
        }
        /// Animation / 动画
        coordinator.animate(alongsideTransition: { context in
            self.backgroundView.alpha = 1.0
        }, completion: nil)
    }
    
    /// Presentation did end / 已经弹出视图
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        if component.canPanDismiss {
            let panGuesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
            presentedViewController.view.addGestureRecognizer(panGuesture)
        }
    }
    
    /// Dismissal will begin / 将要消失时
    public override func dismissalTransitionWillBegin() {
        /// Remove keyboard notifications / 移除键盘通知
        removeObservers()
        /// Background animation / 背景动画
        guard let coordinator = presentedViewController.transitionCoordinator else {
            backgroundView.alpha = 0.0
            return
        }
        coordinator.animate(alongsideTransition: { context in
            self.backgroundView.alpha = 0.0
        }, completion: nil)
    }
    
    /// Dismissal did end / 已经消失
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            backgroundView.removeFromSuperview()
        }
    }

}

// MARK: - Handle Gestures
extension PresentationController {
    
    /// Handle background view tap / 处理背景视图点击
    @objc private func backgroundViewDidTapped() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    /// Handle pan gesture / 处理pan手势
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        guard component.canPanDismiss else { return }
        let offset = gesture.translation(in: presentedView)
        let contentSize = presentedViewController.view.frame.size
        switch gesture.state {
        case .began:
            panStart = offset
        case .changed:
            var alpha: CGFloat = 1.0
            var offsetX: CGFloat = 0
            var offsetY: CGFloat = 0
            switch panDirection {
            case .up:
                offsetY = -min(contentSize.height, max(panStart.y - offset.y, 0))
                alpha = 1 - abs(offsetY / contentSize.height)
            case .down:
                offsetY = max(0, min(offset.y - panStart.y,contentSize.height))
                alpha = 1 - offsetY / contentSize.height
            case .left:
                offsetX = -min(contentSize.width, max(panStart.x - offset.x, 0))
                alpha = 1 - abs(offsetX / contentSize.width)
            case .right:
                offsetX = max(0, min(offset.x - panStart.x, contentSize.width))
                alpha = 1 - offsetX / contentSize.width
            }
            presentedViewController.view.transform = CGAffineTransform(translationX: offsetX, y: offsetY)
            backgroundView.alpha = alpha
        case .ended, .cancelled, .failed:
            var canDismiss: Bool = false
            switch panDirection {
            case .up:
                canDismiss = panStart.y - offset.y > min(contentSize.height / 2, 100)
            case .down:
                canDismiss = offset.y - panStart.y > min(contentSize.height / 2, 100)
            case .left:
                canDismiss = panStart.x - offset.x > min(contentSize.width / 2, 100)
            case .right:
                canDismiss = offset.x - panStart.x > min(contentSize.width / 2, 100)
            }
            if canDismiss {
                backgroundViewDidTapped()
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                    self.presentedViewController.view.transform = CGAffineTransform.identity
                    self.backgroundView.alpha = 1
                })
            }
        default:
            break
        }
    }
    
}

// MARK: - Keyboard
extension PresentationController {
    
    /// Register keyboard and text input notifications / 注册键盘和文本输入通知
    private func registerObservers() {
        /// Register keyboard notifications / 注册键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIApplication.keyboardWillHideNotification, object: nil)
        /// Register text input notifications / 注册输入框通知
        NotificationCenter.default.addObserver(self, selector: #selector(textInputViewDidBeginEditing(notification:)), name: UITextField.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textInputViewDidBeginEditing(notification:)), name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textInputViewDidEndEditing(notification:)), name: UITextField.textDidEndEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textInputViewDidEndEditing(notification:)), name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    /// Remove keyboard and text input notifications / 移除键盘和文本输入通知
    private func removeObservers() {
        /// Remove keyboard notifications / 移除键盘通知
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
        /// Remove text input notifications / 移除输入框通知
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidEndEditingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    /// Keyboard will show / 键盘将要出现
    @objc private func keyboardWillShow(notification: Notification) {
        keyboardFrame = notification.keyboardEndFrame
        keyboardAnimationDuration = notification.keyboardAnimationDuration
        handleKeyboardAdjustAnimation()
    }
    
    /// Keyboard will hide / 键盘将要消失
    @objc private func keyboardWillHide(notification: Notification) {
        keyboardFrame = notification.keyboardEndFrame
        keyboardAnimationDuration = notification.keyboardAnimationDuration
        handleKeyboardAdjustAnimation()
    }
    
    /// Keyboard frame will change / 键盘frame将要改变
    @objc private func keyboardWillChangeFrame(notification: Notification) {
        keyboardFrame = notification.keyboardEndFrame
        keyboardAnimationDuration = notification.keyboardAnimationDuration
        handleKeyboardAdjustAnimation()
    }
    
    /// Text input view began editing / 文本输入视图开始编辑
    @objc private func textInputViewDidBeginEditing(notification: NSNotification) {
        textInputView = notification.object as? UIView
        handleKeyboardAdjustAnimation()
    }
    
    /// Text input view ended editing / 文本输入视图结束编辑
    @objc private func textInputViewDidEndEditing(notification: NSNotification) {
        let inputView = notification.object as? UIView
        if textInputView == inputView {
            textInputView = nil
        }
        handleKeyboardAdjustAnimation()
    }
    
    /// Translate frame based on keyboard position / 基于键盘位置转换frame
    private func translateFrame(keyboardFrame: CGRect, presentedViewFrame: CGRect, inputViewFrame: CGRect) -> CGRect {
        var newFrame = presentedViewFrame
        let keyboardTop = UIScreen.main.bounds.height - keyboardFrame.size.height
        switch component.keyboardTranslationType {
        case .unabgeschirmt(let compress):
            let presentedBottom = presentedViewFrame.maxY + component.keyboardPadding
            let offset = presentedBottom - keyboardTop
            if compress || offset > 0 {
                newFrame.origin.y -= offset
            }
        case .compressInputView:
            let inputViewBottom = inputViewFrame.maxY + component.keyboardPadding
            let offset = inputViewBottom - keyboardTop
            newFrame.origin.y -= offset
        }
        return newFrame
    }
 
    /// Handle keyboard adjustment animation / 处理键盘调整动画
    private func handleKeyboardAdjustAnimation() {
        guard let keyboardFrame = keyboardFrame,
            let keyboardAnimationDuration = keyboardAnimationDuration else { return }
        if let textInputView = textInputView {
            let presentedViewFrame = frameOfPresentedViewInContainerView
            let inputViewFrame = textInputView.convert(textInputView.bounds, to: nil)
            let translatedFrame = translateFrame(keyboardFrame: keyboardFrame, presentedViewFrame: presentedViewFrame, inputViewFrame: inputViewFrame)
            if translatedFrame != presentedViewFrame {
                UIView.setAnimationBeginsFromCurrentState(true)
                UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                    self.presentedView?.frame = translatedFrame
                })
            }
        } else {
            let presentedViewFrame = frameOfPresentedViewInContainerView
            if presentedView?.frame != presentedViewFrame {
                UIView.setAnimationBeginsFromCurrentState(true)
                UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                    self.presentedView?.frame = presentedViewFrame
                })
            }
        }
    }
    
}

extension Notification {
    
    /// Keyboard end frame / 键盘frame
    public var keyboardEndFrame: CGRect? {
        return (userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    /// Keyboard animation duration / 键盘动画时间
    public var keyboardAnimationDuration: TimeInterval? {
        return (userInfo?[UIApplication.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
    }
    
}
