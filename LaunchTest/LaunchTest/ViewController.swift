//
//  ViewController.swift
//  LaunchTest
//
//  Created by muhlenXi on 2018/6/24.
//  Copyright © 2018年 muhlenXi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let thumbnail = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.size.width/2-100, y: 20, width: 200, height: 50)
        button.setTitle("获取加载页", for: .normal)
        button.addTarget(self, action: #selector(self.onClickFetchImageBtn(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        
        thumbnail.frame = CGRect(x: 10, y: 70, width: UIScreen.main.bounds.size.width-20, height: UIScreen.main.bounds.size.height-80)
        self.view.addSubview(thumbnail)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func onClickFetchImageBtn(_ sender: UIButton) {
        if let name = LaunchUtils.getLauchImageName() {
            self.thumbnail.image = UIImage(named: name)
        }
    }
}

