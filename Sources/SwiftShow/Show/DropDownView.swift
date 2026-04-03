//
//  DropDownView.swift
//  SwiftShow
//
//  Created by iOS on 2020/8/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SnapKit

/// Drop-down view that can cover TabBar / 可覆盖TabBar的下拉视图
class DropDownView: UIView {
    
    /// DropDown configuration / DropDown配置
    private var dropDownConfig : ShowDropDownConfig
    
    /// Content view / 内容视图
    private weak var contentVie : UIView?
    
    /// Content size / 内容尺寸
    private var contentSize = CGSize.zero
    
    /// Background touch control / 背景点击控件
    private lazy var backCtl: UIControl = {
        let backCtl = UIControl()
        backCtl.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        return backCtl
    }()
    
    /// Callback type / 回调类型
    typealias CallBack = () -> Void
    
    /// Callback to hide drop-down / 隐藏下拉的回调
    private var hiddenDrop : CallBack?
    
    /// Initialize drop-down view / 初始化下拉视图
    /// - Parameters:
    ///   - contentView: Content view to present / 要展示的内容视图
    ///   - config: DropDown configuration / DropDown配置
    ///   - hiden: Callback when hidden / 隐藏时的回调
    init(contentView: UIView, config : ShowDropDownConfig, hiden : CallBack? = nil) {
        dropDownConfig = config
        let frame = CGRect.init(x: 0, y: config.fromY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - config.fromY)
        super.init(frame: frame)
        clipsToBounds = true
        
        hiddenDrop = hiden
        contentVie = contentView
        contentSize = contentView.bounds.size
        
        // Blur effect background / 毛玻璃效果背景
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: dropDownConfig.effectStyle))
        addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // Apply mask type / 应用遮罩类型
        switch dropDownConfig.maskType {
        case .effect:
            effectView.isHidden = false
            backgroundColor = .clear
        default:
            effectView.isHidden = true
            backgroundColor = dropDownConfig.bgColor
        }
        
        addSubview(backCtl)
        backCtl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // Add content view, initially positioned above visible area / 添加内容视图，初始位置在可见区域上方
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset( -contentSize.height)
            make.centerX.equalToSuperview()
            make.size.equalTo(contentSize)
        }
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Background tapped / 背景被点击
    @objc func backClick(){
        if dropDownConfig.clickOutHidden {
            hiddenDrop?()
        }
    }
    
    /// Show animation / 展示动画
    func showAnimate(_ block: CallBack?){
        
        contentVie?.snp.updateConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(0)
        }
        
        // Apply spring or normal animation / 应用弹性或普通动画
        if dropDownConfig.animateDamping {
            UIView.animate(withDuration: dropDownConfig.animateDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [], animations: {
                self.layoutIfNeeded()
            }) { (finished) in
                block?()
            }
        }else{
            UIView.animate(withDuration: dropDownConfig.animateDuration, animations: {
                self.layoutIfNeeded()
            }) { (finished) in
                block?()
            }

        }
    }
    
    /// Hide animation / 隐藏动画
    func hideAnimate(_ block: CallBack?){
        
        contentVie?.snp.updateConstraints { (make) in
            make.top.equalTo(self.snp.top).offset( -contentSize.height)
        }
        
        UIView.animate(withDuration: dropDownConfig.animateDuration, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            block?()
        }
    }
}
