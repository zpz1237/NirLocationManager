# NirLocationManager
对 CLLocationManager 的简单封装，主要用于获取中文城市名

##用法

* 在 plist 中设置 `NSLocationAlwaysUsageDescription` 和 `NSLocationWhenInUseUsageDescription` 作为提示信息

* 生成 NirLocationManager 实例
```
    let locationManager = NirLocationManager()
```
* 将其代理设置为自身
```
    locationManager.delegate = self
```
* 实现 NirLocationManagerDelegate，并从代理方法中取得数据
