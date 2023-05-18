//
//  LViewController.swift
//  SwiftShow
//
//  Created by iOS on 2020/8/18.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SwiftBrick
import SwiftShow
class LViewController: UIViewController, CAAnimationDelegate, PresentedViewType{
    var presentedViewComponent: PresentedViewComponent?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        let colors = [UIColor.clear,UIColor.purple]
        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 200, height: 200))
        imageView.image = UIImage(named: "Loading")
        
        
        let maskView = UIView(frame: .init(x: 100, y: 100, width: 200, height: 200))
        view.addSubview(maskView)
        maskView.backgroundColor = .gray
        
        let gradient: CAGradientLayer = colors.gradient { gradient in
            gradient.startPoint = CGPoint.init(x: 0, y: 0)
            gradient.endPoint = CGPoint.init(x: 0, y: 1)
            return gradient
        }
        gradient.frame = maskView.bounds
        gradient.drawsAsynchronously = true
        maskView.layer.insertSublayer(gradient, at: 0)
        
        gradient.locations = [1,1]
        
        let animation = CABasicAnimation.init(keyPath: "locations")
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        animation.duration = 1.2
        animation.fromValue = [1,1]
        animation.toValue = [0,0]
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        let group = CAAnimationGroup.init()
        group.animations = [animation]
        group.duration = 1.2
        group.repeatCount = HUGE
        group.autoreverses = true
        gradient.add(group, forKey: "animateLocations")
        
        maskView.mask = imageView
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
