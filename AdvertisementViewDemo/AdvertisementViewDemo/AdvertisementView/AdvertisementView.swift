//
//  AdvertisementView.swift
//  LaunchTest
//
//  Created by muhlenXi on 2018/6/24.
//  Copyright © 2018年 muhlenXi. All rights reserved.
//

import UIKit

class AdvertisementView: UIView {
    /// 广告图片 url
    var imageUrlString = ""
    /// 广告页消失延迟时间（用于广告数据获取）
    var dismissDelaySeconds = 0
    /// 广告页延迟时间定时器
    fileprivate var originalTimer: DispatchSourceTimer?
    /// 跳过按钮倒计时定时器
    fileprivate var adTimer: DispatchSourceTimer?
    /// 广告页延迟时间倒计时是否用完
    private var dismissDelaySecondsOver = false

    /// 跳过按钮倒计时
    var jumpDelaySeconds = 5
    
    /// 启动页
    lazy var thumbnail: UIImageView = {
        let thumbnail_: UIImageView = UIImageView()
        thumbnail_.backgroundColor = UIColor.white
        return thumbnail_
    }()
    
    /// 广告页
    lazy var adThumbnail: UIImageView = {
        let thumbnail_: UIImageView = UIImageView()
        thumbnail_.backgroundColor = UIColor.white
        thumbnail_.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTapImageView(_:)))
        thumbnail_.addGestureRecognizer(tap)
        return thumbnail_
    }()
    
    /// 跳过按钮
    lazy var jumpBtn: UIButton = {
        let jump: UIButton = UIButton()
        jump.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        jump.layer.cornerRadius = 12
        jump.layer.borderWidth = 0.5
        jump.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        jump.titleLabel?.font = UIFont(name: "PingFang SC", size: 14)
        jump.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.8), for: .normal)
        jump.addTarget(self, action: #selector(self.onClickJumpBtn(_:)), for: .touchUpInside)
        return jump
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    // MARK: 显示方法
    /// 显示
    public func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.startDelayTimeCountDown()
        AdvertisementUtils.loadAndStoreImageBy(imageUrlString: self.imageUrlString) { (image) in
            if self.dismissDelaySecondsOver == false {
                self.originalTimer?.cancel()
                self.originalTimer = nil
                
                self.setupADSubView()
                self.updateview(image: image)
            }
        }
    }
    
    /// 消失
    public func dismiss() {
        self.originalTimer?.cancel()
        self.originalTimer = nil
        
        self.adTimer?.cancel()
        self.adTimer = nil
        
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.8, options: .transitionFlipFromLeft, animations: {
            self.removeFromSuperview()
        }, completion: nil)
    }

    
    // MARK: 私有方法
    private  func startDelayTimeCountDown(){
        var duration: Int = dismissDelaySeconds
        self.originalTimer = DispatchSource.makeTimerSource(flags: [], queue: .global())
        self.originalTimer?.schedule(deadline: .now(), repeating: DispatchTimeInterval.seconds(1))
        self.originalTimer?.setEventHandler(handler: {
            duration -= 1
            if duration == 0 {
                DispatchQueue.main.async {
                    self.dismissDelaySecondsOver = true
                    self.dismiss()
                }
                return
            }
        })
        self.originalTimer?.resume()
    }
    
    private func startADDelayTimeCountDown() {
        var duration: Int = jumpDelaySeconds
        self.adTimer = DispatchSource.makeTimerSource(flags: [], queue: .global())
        self.adTimer?.schedule(deadline: .now(), repeating: DispatchTimeInterval.seconds(1))
        self.adTimer?.setEventHandler(handler: {
            if duration != 0 {
                let title = String.init(format: "跳过 %d", duration)
                DispatchQueue.main.async {
                    self.jumpBtn.setTitle(title, for: .normal)
                }
            }
            duration -= 1
            if duration == 0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                    self.dismiss()
                })
                return
            }
        })
        self.adTimer?.resume()
    }
    
    // MARK: - 视图
    private func setupSubviews() {
        self.backgroundColor = UIColor.white
        thumbnail.frame = self.frame
        self.addSubview(thumbnail)
        if let name = AdvertisementUtils.getLauchImageName() {
            thumbnail.image = UIImage(named: name)
        }
    }
   
    private func setupADSubView() {
        adThumbnail.alpha = 0
        adThumbnail.frame = self.frame
        adThumbnail.backgroundColor = UIColor.white
        self.addSubview(adThumbnail)
        
        jumpBtn.frame = CGRect(x: UIScreen.main.bounds.size.width-64-10, y: 20, width: 64, height: 24)
        jumpBtn.setTitle(String.init(format: "跳过 %d", self.jumpDelaySeconds), for: .normal)
        jumpBtn.alpha = 0
        self.addSubview(jumpBtn)
    }
    
    private func updateview(image: UIImage?) {
        self.adThumbnail.image = image
        self.bringSubview(toFront: self.adThumbnail)
        self.bringSubview(toFront: self.jumpBtn)
        
        UIView.animate(withDuration: 0.8, animations: {
            self.adThumbnail.alpha = 1
            self.jumpBtn.alpha = 1
            self.thumbnail.alpha = 0
        }) { (result) in
            self.startADDelayTimeCountDown()
        }
    }
    
    
    // MARK: - 事件方法
    @objc func onClickJumpBtn(_ sender: UIButton) {
        self.dismiss()
    }
    
    @objc func onTapImageView(_ sender: UITapGestureRecognizer) {
        self.dismiss()
    }
}
