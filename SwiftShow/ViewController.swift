//
//  ViewController.swift
//  SwiftDialog
//
//  Created by iOS on 2020/2/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SnapKit
import SwiftBrick
import SwiftyAttributes
class ViewController: JHTableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView.init(image: UIImage.init(named: "timg"))
        self.view.addSubview(imageView)
        self.view.bringSubviewToFront(self.tableView!)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.title = "Show示例"
        self.mainDatas = ["toast中间","toast中间带图片","toast下边","toast上边","toast自定义配置","loading不支持触摸透传","loading+文字不支持触摸透传","loading自定义配置","alert","alert自定义配置","popview","popview自定义配置","dropdown","富文本alert"]
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(JHTableViewCell.self)
        cell.textLabel?.text = self.mainDatas[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            Show.showToast("toast,中间展示")
        case 1:
            Show.showToast("toast，中间展示", image: UIImage.init(named: "share_haoyou_btn"))
        case 2:
            Show.showToast("toast", image: UIImage.init(named: "share_haoyou_btn")) { (config) in
                config.offSetType = .bottom
                config.offSet = 10
                //等等
            }
        case 3:
            Show.showToast("toast", image: UIImage.init(named: "share_haoyou_btn")) { (config) in
                config.offSetType = .top
                config.offSet = 10
                config.imageType = .imageButtonTypeBottom
                //等等
            }
        case 4:
            Show.showToast("toast", image: UIImage.init(named: "share_haoyou_btn")) { (config) in
                config.shadowColor = UIColor.red.cgColor
                config.textColor = .red
                config.imageType = .imageButtonTypeTop
                config.space = 10
                //等等
            }
        case 5:
            Show.showLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                Show.hiddenLoading()
            }
        case 6:
            Show.showLoading("loading...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                Show.hiddenLoading()
            }
        case 7:
            Show.showLoading("触摸透传") { (config) in
                config.imagesArray = self.getImages()
                config.shadowColor = UIColor.red.cgColor
                config.enableEvent = true
                config.space = 15
                //等等
            }
        case 8:
            Show.showAlert(title: "alert", message: "13123123123", leftBtnTitle: "cancle", rightBtnTitle: "done", leftBlock: {
                Show.showToast("点击cancle")
                Show.hiddenAlert()
            }, rightBlock: {
                Show.showToast("点击done")
                Show.hiddenAlert()
            })
        case 9:
            Show.showCustomAlert(title: "alert", titleImage: UIImage.init(named: "share_haoyou_btn"), leftBtnTitle: "cancle", rightBtnTitle: "done", leftBlock: {
                Show.showToast("点击cancle")
                Show.hiddenAlert()
            }, rightBlock: {
                Show.showToast("点击done")
                Show.hiddenAlert()
            }) { (config) in
                //                config.tintColor = .purple
                config.shadowColor = UIColor.red.cgColor
                config.maskType = .effect
            }
        case 10:
            let content = UIImageView.init(frame: CGRect.init(x: 300, y: 100, width: 200, height: 200))
            content.image = UIImage.init(named: "timg")
            //            content.backgroundColor = .red
            Show.showPopView(contentView: content)
        case 11:
            let content = UIButton.init(frame: CGRect.init(x: 300, y: 100, width: 200, height: 200))
            content.setImage(UIImage.init(named: "timg"), for: .normal)
            content.addTarget(self, action: #selector(hideClick), for: .touchUpInside)
            Show.showPopView(contentView: content) { (config) in
                config.showAnimateType = .bottom
                config.clickOutHidden = false
            }
        case 12:
            let content = UIButton.init(frame: CGRect.init(x: 300, y: 100, width: 200, height: 200))
            content.setImage(UIImage.init(named: "timg"), for: .normal)
            content.addTarget(self, action: #selector(hideClick), for: .touchUpInside)
            Show.showCoverTabbarView(contentView: content) {_ in
                print("已经展示")
            } hideClosure: {
                print("已经隐藏")
            } willShowClosure: {
                print("将要展示")
            } willHideClosure: {
                print("将要隐藏")
            }
        case 13:
            Show.showAttributedAlert(attributedTitle: "温馨提醒".withFont(Font15),
                                  attributedMessage: "当前学期内共有".withFont(Font13),
                                  leftBtnAttributedTitle: "我再想想".withTextColor(.orange),
                                  rightBtnAttributedTitle: "好的".withTextColor(.red), rightBlock:  {
                                    
                                  })
        default:
            print("1")
        }
    }
    
    @objc
    func hideClick() {
        Show.hidenPopView {
            print("收起完成")
        }
        
        Show.hidenCoverTabbarView {
            print("asdasdasdasd")
        }
    }
    
    func getImages() -> [UIImage] {
        var loadingImages = [UIImage]()
        
        for index in 0...15 {
            if let image = UIImage.init(named: "icon_kangaroo_global_loading_\(index)") {
                loadingImages.append(image)
            }
        }
        return loadingImages
    }
}

