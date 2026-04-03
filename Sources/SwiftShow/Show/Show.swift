//
//  Show.swift
//  SwiftShow
//
//  Created by iOS on 2020/1/16.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

// MARK: - Toast
extension Show{
    /// Configuration callback for Toast / 适配器回调,用于给适配器参数赋值
    public typealias ConfigToast = ((_ config : ShowToastConfig) -> Void)
    
    /// Show toast notification / 展示toast
    /// - Parameters:
    ///   - title: Title text / 标题文本
    ///   - subTitle: Subtitle text / 副标题文本
    ///   - image: Image (optional) / 图片（可选）
    ///   - config: Toast configuration / toast配置
    public class func toast(_ title: String,
                            subTitle: String? = nil,
                            image: UIImage? = nil,
                            config : ConfigToast? = nil){
        let model = ShowToastConfig()
        config?(model)
        showToast(title: title, subTitle: subTitle, image: image, config: model)
    }
    
    /// Internal method to show toast / 内部展示toast方法
    private class func showToast(title: String,
                                 subTitle: String? = nil,
                                 image: UIImage? = nil,
                                 config: ShowToastConfig){
        
        // Remove existing toast views / 移除已存在的toast视图
        getWindow().subviews.forEach { (view) in
            if view.isKind(of: ToastView.self){
                view.removeFromSuperview()
            }
        }
        
        let toast = ToastView(title: title, subTitle: subTitle, image: image, config: config)
        getWindow().addSubview(toast)
        toast.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            switch config.offSetType {
            case .center:
                make.centerY.equalToSuperview()
            case .top:
                make.top.equalToSuperview().offset(config.offSet)
            case .bottom:
                make.bottom.equalToSuperview().offset(-config.offSet)
            }
            
        }
        
        // Auto dismiss after show time / 到达展示时间后自动消失
        DispatchQueue.main.asyncAfter(deadline: .now() + config.showTime) {
            UIView.animate(withDuration: config.animateDuration, animations: {
                toast.alpha = 0
            }) { (_) in
                toast.removeFromSuperview()
            }
        }
    }
}

// MARK: - Loading
extension Show{
    /// Configuration callback for Loading / 适配器回调,用于给适配器参数赋值
    public typealias ConfigLoading = ((_ config : ShowLoadingConfig) -> Void)
    
    /// Show loading in current view controller / 在当前VC中展示loading
    /// - Parameters:
    ///   - title: Title text / 标题文本
    ///   - subTitle: Subtitle text / 副标题文本
    ///   - config: Loading configuration / loading配置
    public class func loading(_ title : String? = nil,
                              subTitle: String? = nil,
                              config : ConfigLoading? = nil) {
        guard let vc = currentViewController() else {
            return
        }
        
        let model = ShowLoadingConfig()
        config?(model)
        loading(title: title, subTitle: subTitle, onView: vc.view, config: model)
    }
    
    /// Manually hide loading in current view controller / 手动隐藏上层VC中的loading
    public class func hideLoading() {
        guard let vc = currentViewController() else {
            return
        }
        hideLoadingOnView(vc.view)
    }
    
    /// Show loading on window / 在window中展示loading
    /// - Parameters:
    ///   - title: Title text / 标题文本
    ///   - subTitle: Subtitle text / 副标题文本
    ///   - config: Configuration / 配置
    public class func loadingOnWindow(_ title : String? = nil,
                                      subTitle: String? = nil,
                                      config : ConfigLoading? = nil){
        let model = ShowLoadingConfig()
        config?(model)
        loading(title: title, subTitle: subTitle, onView: getWindow(), config: model)
    }
    
    /// Manually hide loading on window / 手动隐藏window中loading
    public class func hideLoadingOnWindow() {
        hideLoadingOnView(getWindow())
    }
    
    /// Show loading on specific view / 在指定view中添加loading
    /// - Parameters:
    ///   - onView: Target view / 目标view
    ///   - title: Title text / 标题文本
    ///   - subTitle: Subtitle text / 副标题文本
    ///   - config: Configuration / 配置
    public class func loadingOnView(_ onView: UIView,
                                    title : String? = nil,
                                    subTitle: String? = nil,
                                    config : ConfigLoading? = nil){
        let model = ShowLoadingConfig()
        config?(model)
        loading(title: title, subTitle: subTitle, onView: onView, config: model)
    }
    
    /// Manually hide loading on specific view / 手动隐藏指定view中loading
    /// - Parameter onView: Target view / 目标view
    public class func hideLoadingOnView(_ onView: UIView) {
        onView.subviews.forEach { (view) in
            if view.isKind(of: LoadingView.self){
                view.removeFromSuperview()
            }
        }
    }
    
    /// Internal method to show loading / 内部展示loading方法
    private class func loading(title: String? = nil,
                               subTitle: String? = nil,
                               onView: UIView? = nil,
                               config : ShowLoadingConfig) {
        let loadingView = LoadingView(title: title, subTitle: subTitle, config: config)
        loadingView.isUserInteractionEnabled = !config.enableEvent
        if let base = onView{
            hideLoadingOnView(base)
            base.addSubview(loadingView)
            base.bringSubviewToFront(loadingView)
            loadingView.layer.zPosition = CGFloat(MAXFLOAT)
        }else{
            hideLoadingOnWindow()
            getWindow().addSubview(loadingView)
        }
        
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
}

// MARK: - Alert
extension Show{
    /// Configuration callback for Alert / 适配器回调,用于给适配器参数赋值
    public typealias ConfigAlert = ((_ config : ShowAlertConfig) -> Void)
    
    /// Default style Alert / 默认样式Alert
    /// - Parameters:
    ///   - title: Title / 标题
    ///   - message: Message / 信息
    ///   - leftBtnTitle: Left button title / 左侧按钮标题
    ///   - rightBtnTitle: Right button title / 右侧按钮标题
    ///   - leftBlock: Left button callback / 左侧按钮回调
    ///   - rightBlock: Right button callback / 右侧按钮回调
    public class func alert(title: String? = nil,
                            message: String?  = nil,
                            leftBtnTitle: String? = nil,
                            rightBtnTitle: String? = nil,
                            leftBlock: LeftCallBack? = nil,
                            rightBlock: RightCallback? = nil) {
        customAlert(title: title,
                    message: message,
                    leftBtnTitle: leftBtnTitle,
                    rightBtnTitle: rightBtnTitle,
                    leftBlock: leftBlock,
                    rightBlock: rightBlock)
    }
    
    /// Attributed text style Alert / 富文本样式Alert
    /// - Parameters:
    ///   - attributedTitle: Attributed title / 富文本标题
    ///   - attributedMessage: Attributed message / 富文本信息
    ///   - leftBtnAttributedTitle: Attributed left button title / 富文本左侧按钮标题
    ///   - rightBtnAttributedTitle: Attributed right button title / 富文本右侧按钮标题
    ///   - leftBlock: Left button callback / 左侧按钮回调
    ///   - rightBlock: Right button callback / 右侧按钮回调
    public class func attributedAlert(attributedTitle : NSAttributedString? = nil,
                                      attributedMessage : NSAttributedString? = nil,
                                      leftBtnAttributedTitle: NSAttributedString? = nil,
                                      rightBtnAttributedTitle: NSAttributedString? = nil,
                                      leftBlock: LeftCallBack? = nil,
                                      rightBlock: RightCallback? = nil) {
        customAlert(attributedTitle: attributedTitle,
                    attributedMessage: attributedMessage,
                    leftBtnAttributedTitle: leftBtnAttributedTitle,
                    rightBtnAttributedTitle: rightBtnAttributedTitle,
                    leftBlock: leftBlock,
                    rightBlock: rightBlock)
    }
    
    /// Custom Alert / 自定义Alert
    /// - Parameters:
    ///   - title: Title / 标题
    ///   - attributedTitle: Attributed title / 富文本标题
    ///   - image: Top image / 顶图
    ///   - message: Message / 信息
    ///   - attributedMessage: Attributed message / 富文本信息
    ///   - leftBtnTitle: Left button title / 左侧按钮标题
    ///   - leftBtnAttributedTitle: Attributed left button title / 富文本左侧按钮标题
    ///   - rightBtnTitle: Right button title / 右侧按钮标题
    ///   - rightBtnAttributedTitle: Attributed right button title / 富文本右侧按钮标题
    ///   - leftBlock: Left button callback / 左侧按钮回调
    ///   - rightBlock: Right button callback / 右侧按钮回调
    ///   - config: Alert configuration, nil for default / Alert配置，不传为默认样式
    public class func customAlert(title: String? = nil,
                                  attributedTitle : NSAttributedString? = nil,
                                  image: UIImage? = nil,
                                  message: String?  = nil,
                                  attributedMessage : NSAttributedString? = nil,
                                  leftBtnTitle: String? = nil,
                                  leftBtnAttributedTitle: NSAttributedString? = nil,
                                  rightBtnTitle: String? = nil,
                                  rightBtnAttributedTitle: NSAttributedString? = nil,
                                  leftBlock: LeftCallBack? = nil,
                                  rightBlock: RightCallback? = nil,
                                  config : ConfigAlert? = nil) {
        hideAlert()
        
        let model = ShowAlertConfig()
        config?(model)
        
        let alertView = AlertView(title: title,
                                  attributedTitle: attributedTitle,
                                  image: image,
                                  message: message,
                                  attributedMessage: attributedMessage,
                                  leftBtnTitle: leftBtnTitle,
                                  leftBtnAttributedTitle: leftBtnAttributedTitle,
                                  rightBtnTitle: rightBtnTitle,
                                  rightBtnAttributedTitle: rightBtnAttributedTitle,
                                  config: model)
        alertView.leftBlock = leftBlock
        alertView.rightBlock = rightBlock
        alertView.dismissBlock = {
            hideAlert()
        }
        getWindow().addSubview(alertView)
        alertView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    /// Manually hide Alert / 手动隐藏Alert
    public class func hideAlert() {
        getWindow().subviews.forEach { (view) in
            if view.isKind(of: AlertView.self){
                
                UIView.animate(withDuration: 0.3, animations: {
                    view.alpha = 0
                }) { (_) in
                    view.removeFromSuperview()
                }
            }
        }
    }
    
}

// MARK: - Pop
extension Show{
    /// Configuration callback for PopView / 适配器回调,用于给适配器参数赋值
    public typealias ConfigPop = ((_ config : ShowPopViewConfig) -> Void)
    
    /// Show pop-up view / 弹出view
    /// - Parameters:
    ///   - contentView: Content view to be presented / 被弹出的View
    ///   - config: PopView configuration / popview配置
    ///   - showClosure: Show callback / 弹出回调
    ///   - hideClosure: Hide callback / 收起回调
    public class func pop(_ contentView: UIView,
                          config : ConfigPop? = nil,
                          showClosure: CallBack? = nil,
                          hideClosure: CallBack? = nil) {
        
        // Remove existing pop views / 移除已存在的pop视图
        getWindow().subviews.forEach { (view) in
            if view.isKind(of: PopView.self){
                view.removeFromSuperview()
            }
        }
        
        showPopCallBack = showClosure
        hidePopCallBack = hideClosure
        
        let model = ShowPopViewConfig()
        config?(model)
        
        let popView = PopView.init(contentView: contentView, config: model) {
            hidePop()
        }
        
        getWindow().addSubview(popView)
        
        popView.showAnimate()
        
        showPopCallBack?()
    }
    
    /// Manually dismiss pop view / 手动收起popview
    /// - Parameter complete: Completion callback / 完成回调
    public class func hidePop(_ complete : (() -> Void)? = nil ) {
        getWindow().subviews.forEach { (view) in
            if view.isKind(of: PopView.self){
                let popView : PopView = view as! PopView
                popView.hideAnimate {
                    UIView.animate(withDuration: 0.1, animations: {
                        view.alpha = 0
                    }) { (_) in
                        complete?()
                        view.removeFromSuperview()
                        hidePopCallBack?()
                    }
                }
            }
        }
    }
    
}

// MARK: - DropDown
extension Show{
    
    /// Show drop-down view from NavBar or VC's view, can cover TabBar / 从NavBar或VC的view中弹出下拉视图,可以盖住Tabbar
    /// - Parameters:
    ///   - contentView: Content view to be presented / 被弹出的view
    ///   - config: Configuration callback / 配置回调
    ///   - showClosure: Show callback / 展示回调
    ///   - hideClosure: Hide callback / 隐藏回调
    ///   - willShowClosure: Will show callback / 即将展示回调
    ///   - willHideClosure: Will hide callback / 即将收起回调
    public class func coverTabbar(_ contentView: UIView,
                                  config: ((_ config : ShowDropDownConfig) -> Void)? = nil,
                                  showClosure: CallBack? = nil,
                                  hideClosure: CallBack? = nil,
                                  willShowClosure: CallBack? = nil,
                                  willHideClosure: CallBack? = nil) {
        
        if !isHaveCoverTabbarView() {
            
            showCoverCallBack = showClosure
            hideCoverCallBack = hideClosure
            willShowCoverCallBack = willShowClosure
            willHideCoverCallBack = willHideClosure
            
            willShowCoverCallBack?()
            let model = ShowDropDownConfig()
            config?(model)
            
            let popView = DropDownView.init(contentView: contentView, config: model) {
                hideCoverTabbar()
            }
            
            getWindow().rootViewController?.view.addSubview(popView)
            
            popView.showAnimate {
                showCoverCallBack?()
            }
            
        }
        
    }
    
    /// Whether a DropDown view is currently showing / 当前是否正在展示DropDown
    /// - Returns: true/false
    public class func isHaveCoverTabbarView() -> Bool{
        var isHave = false
        getWindow().rootViewController?.view.subviews.forEach { (view) in
            if view.isKind(of: DropDownView.self){
                isHave = true
            }
        }
        return isHave
    }
    
    /// Manually hide DropDown / 手动隐藏DropDown
    /// - Parameter complete: Completion callback / 完成回调
    public class func hideCoverTabbar(_ complete : (() -> Void)? = nil ) {
        getWindow().rootViewController?.view.subviews.forEach { (view) in
            if view.isKind(of: DropDownView.self){
                let popView : DropDownView = view as! DropDownView
                willHideCoverCallBack?()
                popView.hideAnimate {
                    UIView.animate(withDuration: 0.1, animations: {
                        view.alpha = 0
                    }) { (_) in
                        complete?()
                        view.removeFromSuperview()
                        hideCoverCallBack?()
                    }
                }
            }
        }
    }
    
}

// MARK: - Utility methods for getting top-level views
// MARK: - 获取最上层视图

public class Show{
    /// Generic callback / 通用回调
    public typealias CallBack = () -> Void
    
    // DropDown callbacks / DropDown回调
    private static var showCoverCallBack : CallBack?
    private static var hideCoverCallBack : CallBack?
    private static var willShowCoverCallBack : CallBack?
    private static var willHideCoverCallBack : CallBack?
    
    // PopView callbacks / PopView回调
    private static var showPopCallBack : CallBack?
    private static var hidePopCallBack : CallBack?
    
    /// Get the key window / 获取key window
    private class func getWindow() -> UIWindow {
        var window = UIApplication.shared.keyWindow
        // Check if it's the currently displayed window / 是否为当前显示的window
        if window?.windowLevel != UIWindow.Level.normal{
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == UIWindow.Level.normal{
                    window = windowTemp
                    break
                }
            }
        }
        return window!
    }
    
    /// Get the top view controller from window / 获取顶层VC 根据window
    public class func currentViewController() -> UIViewController? {
        let vc = getWindow().rootViewController
        return getCurrentViewController(withCurrentVC: vc)
    }
    
    /// Recursively find the top view controller / 根据控制器获取 顶层控制器 递归
    private class func getCurrentViewController(withCurrentVC VC :UIViewController?) -> UIViewController? {
        if VC == nil {
            debugPrint("🌶： 找不到顶层控制器 / Top view controller not found")
            return nil
        }
        if let presentVC = VC?.presentedViewController {
            // Modal presented view controller / modal出来的 控制器
            return getCurrentViewController(withCurrentVC: presentVC)
        }
        else if let splitVC = VC as? UISplitViewController {
            // UISplitViewController root controller / UISplitViewController 的跟控制器
            if splitVC.viewControllers.count > 0 {
                return getCurrentViewController(withCurrentVC: splitVC.viewControllers.last)
            }else{
                return VC
            }
        }
        else if let tabVC = VC as? UITabBarController {
            // UITabBarController root controller / tabBar 的跟控制器
            if tabVC.viewControllers != nil {
                return getCurrentViewController(withCurrentVC: tabVC.selectedViewController)
            }else{
                return VC
            }
        }
        else if let naiVC = VC as? UINavigationController {
            // Navigation controller / 控制器是 nav
            if naiVC.viewControllers.count > 0 {
                return getCurrentViewController(withCurrentVC:naiVC.visibleViewController)
            }else{
                return VC
            }
        }
        else {
            // Return top view controller / 返回顶控制器
            return VC
        }
    }
}
