//
//  LaunchView.swift
//  LaunchTest
//
//  Created by muhlenXi on 2018/6/24.
//  Copyright © 2018年 muhlenXi. All rights reserved.
//

import UIKit

class LaunchView: UIView {

    lazy var thumbnail: UIImageView = {
        let thumbnail_: UIImageView = UIImageView()
        thumbnail_.isUserInteractionEnabled = true
        return thumbnail_
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    // MARK: Private method
    public func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    public func dismiss() {
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.8, options: .curveEaseInOut, animations: {
            self.removeFromSuperview()
        }, completion: nil)
    }
    
    private func setupSubviews() {

        thumbnail.frame = self.bounds
        self.addSubview(thumbnail)
        if let name = LaunchUtils.getLauchImageName() {
            thumbnail.image = UIImage(named: name)
        }
    }
}
