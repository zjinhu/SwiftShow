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

//import MLImage
//import MLKit
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
        self.mainDatas = ["toast中间","toast中间带图片","toast下边","toast上边","toast自定义配置","loading不支持触摸透传","loading+文字不支持触摸透传","loading自定义配置","alert","alert自定义配置","popview","popview自定义配置","dropdown","富文本alert","Present"]
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(JHTableViewCell.self)
        cell.textLabel?.text = self.mainDatas[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            Show.toast("toast,中间展示")
        case 1:
            Show.toast("toast，中间展示", image: UIImage.init(named: "share_haoyou_btn"))
        case 2:
            Show.toast("toast", image: UIImage.init(named: "share_haoyou_btn")) { (config) in
                config.offSetType = .bottom
                config.offSet = 10
                //等等
            }
        case 3:
            Show.toast("所有公职人员、特别是干部官员的家人都须低调做人", subTitle:"所有公职人员、特别是干部官员的家人都须低调做人，在外发生争执不可摆谱撒泼，更不可胡乱显示“实力”，否则一定会搞出一地鸡毛，付出代价。 有钱人也一样，不要显富，更不要以富压人，不要以富谋招人恨的特权，否则同样会积累对自己的潜在危机。 深圳“宾利大战劳斯莱斯”，成了丑闻。公众对那个车位的是非并非很感兴趣，更关心那个“官太太”老公和劳斯莱斯车主都是什么来头，有多富，以及为什么素质又这么低。 互联网是平民舆论场，而且只要是足够大的舆论场，它的价值取向一定是老百姓主导的。这很公平，因为达官显贵的资源多，享受了更多权利和权力 ，舆论场更多连接老百姓的的情感和诉求，这是世间应有的平衡，是正义的一部分。 当深圳那个“官太太”叫喊“我家有50辆宾利”时，她基本就是把老公毁了，她的车位被占这点理，远不足以抵消公众对她家到底有多少财富以及来源是否合法的质疑。调查已经势在必行，如果她家确有50辆宾利所对应的财富，她老公能讲清楚的几率很低。即使她家没那么富，她老公作为国企高管也将很难避免因此栽个大跟头。 劳斯莱斯车主经这一曝光，等着他的应该也不会是啥好事。", image: UIImage.init(named: "share_haoyou_btn")) { (config) in
                config.offSetType = .top
                config.offSet = 100
                config.imageType = .left
                config.padding = 30
                config.cornerRadius = 30
                //等等
            }
        case 4:
            Show.toast("toast", image: UIImage.init(named: "share_haoyou_btn")) { (config) in
                config.shadowColor = UIColor.red.cgColor
                config.titleColor = .red
                config.imageType = .top
                config.spaceImage = 10
                //等等
            }
        case 5:
            Show.loading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                Show.hideLoading()
            }
        case 6:
            Show.loading("loading...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                Show.hideLoading()
            }
        case 7:
            Show.loading("触摸透传", subTitle: "加载中") { (config) in
                config.imagesArray = self.getImages()
                config.shadowColor = UIColor.red.cgColor
                config.enableEvent = true
                config.spaceImage = 15
                config.imageType = .left
                //等等
            }
        case 8:
            Show.alert(title: "alert", message: "13123123123", leftBtnTitle: "cancle", rightBtnTitle: "done", leftBlock: {
                Show.toast("点击cancle")
                Show.hideAlert()
            }, rightBlock: {
                Show.toast("点击done")
                Show.hideAlert()
            })
        case 9:
            Show.customAlert(title: "alert", image: UIImage.init(named: "share_haoyou_btn"), message: "13123123123", leftBtnTitle: "cancle", rightBtnTitle: "done", leftBlock: {
                Show.toast("点击cancle")
                Show.hideAlert()
            }, rightBlock: {
                Show.toast("点击done")
                Show.hideAlert()
            }) { (config) in
                //                config.tintColor = .purple
                config.shadowColor = UIColor.red.cgColor
                config.maskType = .color
            }
        case 10:
            let content = UIImageView.init(frame: CGRect.init(x: 300, y: 100, width: 200, height: 200))
            content.image = UIImage.init(named: "timg")
            Show.pop(content)
        case 11:
            let content = UIButton.init(frame: CGRect.init(x: 300, y: 100, width: 200, height: 200))
            content.setImage(UIImage.init(named: "timg"), for: .normal)
            content.addTarget(self, action: #selector(hideClick), for: .touchUpInside)
            Show.pop(content) { (config) in
                config.showAnimateType = .bottom
                config.clickOutHidden = false
            }
        case 12:
            let content = UIButton.init(frame: CGRect.init(x: 300, y: 100, width: 200, height: 200))
            content.setImage(UIImage.init(named: "timg"), for: .normal)
            content.addTarget(self, action: #selector(hideClick), for: .touchUpInside)
            Show.coverTabbar(content) {_ in
                print("已经展示")
            } hideClosure: {
                print("已经隐藏")
            } willShowClosure: {
                print("将要展示")
            } willHideClosure: {
                print("将要隐藏")
            }
        case 13:
            Show.attributedAlert(attributedTitle: "温馨提醒".withFont(Font15),
                                  attributedMessage: "当前学期内共有".withFont(Font13),
                                  leftBtnAttributedTitle: "我再想想".withTextColor(.orange),
                                  rightBtnAttributedTitle: "好的".withTextColor(.red), rightBlock:  {

                                  })
        default:
//            let inputVC = LViewController()
//            var component = PresentedViewComponent(contentSize: CGSize(width: view.bounds.width, height: 300))
//            component.contentSize = CGSize(width: view.bounds.width, height: 300)
//            component.presentTransitionType = .translation(origin: .bottomOutOfLine)
//            component.destination = .bottomBaseline
//            inputVC.presentedViewComponent = component
//            presentViewController(inputVC)
            
            break
//            let options = SelfieSegmenterOptions()
//            options.segmenterMode = .singleImage
//            options.shouldEnableRawSizeMask = true
//            let segmenter = Segmenter.segmenter(options: options)
//            let image = UIImage(named: "ImagePerson")
//            let visionImage = VisionImage(image: image!)
//            visionImage.orientation = image!.imageOrientation
//
//            segmenter.process(visionImage) {[weak self] mask, error in
//              guard let `self` = self else {
//                print("Self is nil!")
//                return
//              }
//
//                guard error == nil, let mask = mask else {
//                  return
//                }
//
//                guard let imageBuffer = ViewController.createImageBuffer(from: image!) else {
//                  return
//                }
//
//                ViewController.applySegmentationMask(
//                  mask: mask, to: imageBuffer,
//                  backgroundColor: UIColor.purple.withAlphaComponent(0.5),
//                  foregroundColor: nil)
//                let maskedImage = ViewController.createUIImage(from: imageBuffer, orientation: .up)
//
//                let imageView = UIImageView()
//                imageView.frame = self.view.bounds
//                imageView.contentMode = .scaleAspectFit
//                imageView.image = maskedImage
//                self.view.addSubview(imageView)
//            }

        }
    }
    
    @objc
    func hideClick() {
        Show.hidePop {
            print("收起完成")
        }
        
        Show.hideCoverTabbar {
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
//
//    static func createImageBuffer(from image: UIImage) -> CVImageBuffer? {
//      guard let cgImage = image.cgImage else { return nil }
//      let width = cgImage.width
//      let height = cgImage.height
//
//      var buffer: CVPixelBuffer? = nil
//      CVPixelBufferCreate(
//        kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, nil,
//        &buffer)
//      guard let imageBuffer = buffer else { return nil }
//
//      let flags = CVPixelBufferLockFlags(rawValue: 0)
//      CVPixelBufferLockBaseAddress(imageBuffer, flags)
//      let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
//      let colorSpace = CGColorSpaceCreateDeviceRGB()
//      let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
//      let context = CGContext(
//        data: baseAddress, width: width, height: height, bitsPerComponent: 8,
//        bytesPerRow: bytesPerRow, space: colorSpace,
//        bitmapInfo: (CGImageAlphaInfo.premultipliedFirst.rawValue
//          | CGBitmapInfo.byteOrder32Little.rawValue))
//
//      if let context = context {
//        let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
//        context.draw(cgImage, in: rect)
//        CVPixelBufferUnlockBaseAddress(imageBuffer, flags)
//        return imageBuffer
//      } else {
//        CVPixelBufferUnlockBaseAddress(imageBuffer, flags)
//        return nil
//      }
//    }
//
//    static func applySegmentationMask(
//      mask: SegmentationMask, to imageBuffer: CVImageBuffer,
//      backgroundColor: UIColor?, foregroundColor: UIColor?
//    ) {
//      assert(
//        CVPixelBufferGetPixelFormatType(imageBuffer) == kCVPixelFormatType_32BGRA,
//        "Image buffer must have 32BGRA pixel format type")
//
//      let width = CVPixelBufferGetWidth(mask.buffer)
//      let height = CVPixelBufferGetHeight(mask.buffer)
//      assert(CVPixelBufferGetWidth(imageBuffer) == width, "Width must match")
//      assert(CVPixelBufferGetHeight(imageBuffer) == height, "Height must match")
//
//      if backgroundColor == nil && foregroundColor == nil {
//        return
//      }
//
//      let writeFlags = CVPixelBufferLockFlags(rawValue: 0)
//      CVPixelBufferLockBaseAddress(imageBuffer, writeFlags)
//      CVPixelBufferLockBaseAddress(mask.buffer, CVPixelBufferLockFlags.readOnly)
//
//      let maskBytesPerRow = CVPixelBufferGetBytesPerRow(mask.buffer)
//      var maskAddress =
//        CVPixelBufferGetBaseAddress(mask.buffer)!.bindMemory(
//          to: Float32.self, capacity: maskBytesPerRow * height)
//
//      let imageBytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
//      var imageAddress = CVPixelBufferGetBaseAddress(imageBuffer)!.bindMemory(
//        to: UInt8.self, capacity: imageBytesPerRow * height)
//
//      var redFG: CGFloat = 0.0
//      var greenFG: CGFloat = 0.0
//      var blueFG: CGFloat = 0.0
//      var alphaFG: CGFloat = 0.0
//      var redBG: CGFloat = 0.0
//      var greenBG: CGFloat = 0.0
//      var blueBG: CGFloat = 0.0
//      var alphaBG: CGFloat = 0.0
//
//      let backgroundColor = backgroundColor != nil ? backgroundColor : .clear
//      let foregroundColor = foregroundColor != nil ? foregroundColor : .clear
//      backgroundColor!.getRed(&redBG, green: &greenBG, blue: &blueBG, alpha: &alphaBG)
//      foregroundColor!.getRed(&redFG, green: &greenFG, blue: &blueFG, alpha: &alphaFG)
//
//      for _ in 0...(height - 1) {
//        for col in 0...(width - 1) {
//          let pixelOffset = col * 4
//          let blueOffset = pixelOffset
//          let greenOffset = pixelOffset + 1
//          let redOffset = pixelOffset + 2
//          let alphaOffset = pixelOffset + 3
//
//          let maskValue: CGFloat = CGFloat(maskAddress[col])
//          let backgroundRegionRatio: CGFloat = 1.0 - maskValue
//          let foregroundRegionRatio = maskValue
//
//          let originalPixelRed: CGFloat =
//            CGFloat(imageAddress[redOffset]) / 255.0
//          let originalPixelGreen: CGFloat =
//            CGFloat(imageAddress[greenOffset]) / 255.0
//          let originalPixelBlue: CGFloat =
//            CGFloat(imageAddress[blueOffset]) / 255.0
//          let originalPixelAlpha: CGFloat =
//            CGFloat(imageAddress[alphaOffset]) / 255.0
//
//          let redOverlay = redBG * backgroundRegionRatio + redFG * foregroundRegionRatio
//          let greenOverlay = greenBG * backgroundRegionRatio + greenFG * foregroundRegionRatio
//          let blueOverlay = blueBG * backgroundRegionRatio + blueFG * foregroundRegionRatio
//          let alphaOverlay = alphaBG * backgroundRegionRatio + alphaFG * foregroundRegionRatio
//
//          // Calculate composite color component values.
//          // Derived from https://en.wikipedia.org/wiki/Alpha_compositing#Alpha_blending
//          let compositeAlpha: CGFloat = ((1.0 - alphaOverlay) * originalPixelAlpha) + alphaOverlay
//          var compositeRed: CGFloat = 0.0
//          var compositeGreen: CGFloat = 0.0
//          var compositeBlue: CGFloat = 0.0
//          // Only perform rgb blending calculations if the output alpha is > 0. A zero-value alpha
//          // means none of the color channels actually matter, and would introduce division by 0.
//          if abs(compositeAlpha) > CGFloat(Float.ulpOfOne) {
//            compositeRed =
//              (((1.0 - alphaOverlay) * originalPixelAlpha * originalPixelRed)
//                + (alphaOverlay * redOverlay)) / compositeAlpha
//            compositeGreen =
//              (((1.0 - alphaOverlay) * originalPixelAlpha * originalPixelGreen)
//                + (alphaOverlay * greenOverlay)) / compositeAlpha
//            compositeBlue =
//              (((1.0 - alphaOverlay) * originalPixelAlpha * originalPixelBlue)
//                + (alphaOverlay * blueOverlay)) / compositeAlpha
//          }
//
//          imageAddress[redOffset] = UInt8(compositeRed * 255.0)
//          imageAddress[greenOffset] = UInt8(compositeGreen * 255.0)
//          imageAddress[blueOffset] = UInt8(compositeBlue * 255.0)
//        }
//
//        imageAddress += imageBytesPerRow / MemoryLayout<UInt8>.size
//        maskAddress += maskBytesPerRow / MemoryLayout<Float32>.size
//      }
//
//      CVPixelBufferUnlockBaseAddress(imageBuffer, writeFlags)
//      CVPixelBufferUnlockBaseAddress(mask.buffer, CVPixelBufferLockFlags.readOnly)
//    }
//
//    static func createUIImage(
//      from imageBuffer: CVImageBuffer,
//      orientation: UIImage.Orientation
//    ) -> UIImage? {
//      let ciImage = CIImage(cvPixelBuffer: imageBuffer)
//      let context = CIContext(options: nil)
//      guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
//      return UIImage(cgImage: cgImage, scale: 1, orientation: orientation)
//    }
}

