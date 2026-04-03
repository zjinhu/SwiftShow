//
//  PopView.swift
//  SwiftShow
//
//  Created by iOS on 2020/1/16.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SnapKit

/// Pop-up view / 弹出视图
public class PopView: UIView {

    /// PopView configuration / PopView配置
    private var popViewConfig : ShowPopViewConfig
    
    /// Background touch control / 背景点击控件
    private lazy var backCtl: UIControl = {
        let backCtl = UIControl()
        backCtl.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        return backCtl
    }()
    
    /// Content view / 内容视图
    private weak var contentVie : UIView?
    
    /// Callback to hide pop / 隐藏pop的回调
    typealias HiddenPop = () -> Void
    private var hiddenPop : HiddenPop?
    
    /// Content size / 内容尺寸
    private var contentSize = CGSize.zero
    
    /// Initialize pop view / 初始化弹出视图
    /// - Parameters:
    ///   - contentView: Content view to present / 要展示的内容视图
    ///   - config: PopView configuration / PopView配置
    ///   - hidenHandle: Callback when hidden / 隐藏时的回调
    init(contentView: UIView,
         config : ShowPopViewConfig,
         hidenHandle : HiddenPop? = nil) {
        
        popViewConfig = config
        
        super.init(frame: UIScreen.main.bounds)
        clipsToBounds = true
        
        contentVie = contentView
        contentSize = contentView.bounds.size
        hiddenPop = hidenHandle
        
        // Blur effect background / 毛玻璃效果背景
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: popViewConfig.effectStyle))
        addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // Apply mask type / 应用遮罩类型
        switch popViewConfig.maskType {
        case .effect:
            effectView.isHidden = false
            backgroundColor = .clear
        default:
            effectView.isHidden = true
            backgroundColor = popViewConfig.bgColor
        }
        
        addSubview(backCtl)
        backCtl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(contentView)
        
        // Set initial position based on animation type / 根据动画类型设置初始位置
        switch popViewConfig.showAnimateType {
        case .top:
            contentView.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.top).offset( -contentSize.height)
                make.centerX.equalToSuperview()
                make.size.equalTo(contentSize)
            }
        case .left:
            contentView.snp.makeConstraints { (make) in
                make.left.equalTo(self.snp.left).offset( -contentSize.width)
                make.centerY.equalToSuperview()
                make.size.equalTo(contentSize)
            }
        case .bottom:
            contentView.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(contentSize.height)
                make.centerX.equalToSuperview()
                make.size.equalTo(contentSize)
            }
        case .right:
            contentView.snp.makeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(contentSize.width)
                make.centerY.equalToSuperview()
                make.size.equalTo(contentSize)
            }
        case .center:
            contentView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(contentSize)
            }
            contentView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)

        default:
            debugPrint("")
        }
        
        layoutIfNeeded()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Background tapped / 背景被点击
    @objc func backClick(){
        if popViewConfig.clickOutHidden {
          hiddenPop?()
        } 
    }
    
    /// Show animation / 展示动画
    func showAnimate(){
        
        switch popViewConfig.showAnimateType {
        case .top:
            contentVie?.snp.updateConstraints { (make) in
                make.top.equalTo(self.snp.top).offset(0)
            }
        case .left:
            contentVie?.snp.updateConstraints { (make) in
                make.left.equalTo(self.snp.left).offset(0)
            }
        case .bottom:
            contentVie?.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(0)
            }
        case .right:
            contentVie?.snp.updateConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(0)
            }
        case .center:
            UIView.animate(withDuration: popViewConfig.animateDuration) {
                self.contentVie?.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            }
            return
        default:
            debugPrint("")
        }
        
        // Apply spring or normal animation / 应用弹性或普通动画
        if popViewConfig.animateDamping {
            UIView.animate(withDuration: popViewConfig.animateDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [], animations: {
                self.layoutIfNeeded()
            }) { (finished) in
                
            }
        }else{
            UIView.animate(withDuration: popViewConfig.animateDuration) {
                self.layoutIfNeeded()
            }
        }
     }
    
    /// Hide animation / 隐藏动画
    func hideAnimate(_ block : HiddenPop?){
        
        switch popViewConfig.showAnimateType {
        case .top:
            contentVie?.snp.updateConstraints { (make) in
                make.top.equalTo(self.snp.top).offset( -contentSize.height)
            }
            
        case .left:
            contentVie?.snp.updateConstraints { (make) in
                make.left.equalTo(self.snp.left).offset( -contentSize.width)
            }
        case .bottom:
            contentVie?.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(contentSize.height)
            }
        case .right:
            contentVie?.snp.updateConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(contentSize.width)
            }
        case .center:
            UIView.animate(withDuration: popViewConfig.animateDuration, animations: {
                self.contentVie?.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
            }) { (finished) in
                block?()
            }
            return
        default:
            debugPrint("")
        }
        UIView.animate(withDuration: popViewConfig.animateDuration, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            block?()
        }
    }
    
}
