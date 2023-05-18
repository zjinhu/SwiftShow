//
//  UIView+KeyboardListener.swift
//  KeyboardListener (https://github.com/iLiuChang/KeyboardListener)
//
//  Created by 刘畅 on 2022/5/31.
//

import UIKit
private var UIViewKeyboardListenerKey = "UIViewKeyboardListenerKey"
public extension UIView {
    
    /// Add keyboard listener.
    /// Once detected keyboard covering `UITextField/UITextView` will automatically change the current view's `transform`.
    /// - Parameter keyboardSpacing: The spacing from the top of the keyboard to the bottom of the current view.
    func addKeyboardListener(_ keyboardSpacing: CGFloat = 0.0) {
        let listener = UIViewKeyboardListener(transformView: self)
        listener.keyboardSpacing = keyboardSpacing
        objc_setAssociatedObject(self, &UIViewKeyboardListenerKey, listener, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// Remove keyboard listener.
    func removeKeyboardListener() {
        objc_setAssociatedObject(self, &UIViewKeyboardListenerKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

private class UIViewKeyboardListener {
    var keyboardSpacing: CGFloat = 0.0
    var transformView: UIView!
    var currentTextInput: UIView?
    var currentUserInfo: [AnyHashable : Any]?

    convenience init(transformView: UIView) {
        self.init()
        self.transformView = transformView
        addKeyboardObserver()
    }
    
    deinit {
        removeKeyboardObserver()
    }

    func addKeyboardObserver() {
        #if swift(>=4.2)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textInputDidBeginEditing(_:)), name: UITextField.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textInputDidEndEditing(_:)), name: UITextField.textDidEndEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textInputDidBeginEditing(_:)), name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textInputDidEndEditing(_:)), name: UITextView.textDidEndEditingNotification, object: nil)
        #elseif swift(>=4.0)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textInputDidBeginEditing(_:)), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textInputDidEndEditing(_:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textInputDidBeginEditing(_:)), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textInputDidEndEditing(_:)), name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
        #endif
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func makeKeyboardWillShow() {
        guard let currentWindow = self.transformView.window else {
            return
        }

        guard let observerView = self.currentTextInput,
              let userInfo = self.currentUserInfo else {
            return
        }
        var duration = 0.0
        #if swift(>=4.2)
        guard let rectValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        if let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
            duration = durationValue.doubleValue
        }

        #elseif swift(>=4.0)
        guard let rectValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        if let durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            duration = durationValue.doubleValue
        }
        #endif
        let convertRect = observerView.convert(observerView.bounds, to: currentWindow)
        let telMaxY = convertRect.maxY
        let keyboardH = rectValue.cgRectValue.size.height
        let keyboardY = UIScreen.main.bounds.size.height-keyboardH
        if (duration <= 0.0){
            duration = 0.25
        }
        if (telMaxY > keyboardY) {
            UIView.animate(withDuration: duration) {
                self.transformView.transform = CGAffineTransform(translationX: 0, y: keyboardY - telMaxY - self.keyboardSpacing)
            }
        }
        self.currentUserInfo = nil
        self.currentTextInput = nil
    }
    
    @objc func keyboardWillShow(_ notification: Foundation.Notification) {
        if (self.transformView.window == nil) {
            return
        }
        self.currentUserInfo = notification.userInfo
        makeKeyboardWillShow()
    }
    
    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
        if (self.transformView.transform == CGAffineTransform.identity) {
            return
        }
        var duration = 0.0
        #if swift(>=4.2)
        if let durationValue = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
            duration = durationValue.doubleValue
        }
        #elseif swift(>=4.0)
        if let durationValue = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            duration = durationValue.doubleValue
        }
        #endif

        if (duration <= 0.0){
            duration = 0.25
        }

        UIView.animate(withDuration: duration) {
            self.transformView.transform = CGAffineTransform.identity
        }

    }
    
    @objc func textInputDidBeginEditing(_ notification: Foundation.Notification) {
        guard let view = notification.object as? UIView else {
            return
        }
        if (self.transformView.window != nil) {
            self.currentTextInput = view
        }
        makeKeyboardWillShow()
    }

    @objc func textInputDidEndEditing(_ notification: Foundation.Notification) {
        self.currentTextInput = nil
    }

}
