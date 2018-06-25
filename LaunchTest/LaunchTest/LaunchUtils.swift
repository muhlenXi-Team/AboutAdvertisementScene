//
//  LaunchUtils.swift
//  LaunchTest
//
//  Created by muhlenXi on 2018/6/25.
//  Copyright © 2018年 muhlenXi. All rights reserved.
//

import Foundation
import UIKit

class LaunchUtils {
    static func getLauchImageName() -> String? {
        if let infoDictionary = Bundle.main.infoDictionary, let launchImages = infoDictionary["UILaunchImages"] as? [[String: Any]] {
            let imageSizeValue = "{\(Int(UIScreen.main.bounds.size.width)), \(Int(UIScreen.main.bounds.size.height))}"
            let orientationValue = "Portrait"
            for dict in launchImages {
                if let size = dict["UILaunchImageSize"] as? String, size == imageSizeValue {
                    if let orientation = dict["UILaunchImageOrientation"] as? String, orientation == orientationValue{
                        if let imageName = dict["UILaunchImageName"] as? String {
                            return imageName
                        }
                    }
                }
            }
        }
        return nil
    }
}
