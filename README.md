# About Advertisement Scene

一个简单的启动广告页面 demo

#### 如何获取 App 启动页的 Launch Image name？

```swift
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
```

