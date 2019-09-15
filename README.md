
<p align="center">
  <img src="https://raw.githubusercontent.com/ripperhe/Debugo/master/docs/_media/debugo.png" />
</p>

# Debugo

[![Version](https://img.shields.io/cocoapods/v/Debugo.svg?style=flat)](https://cocoapods.org/pods/Debugo)
[![License](https://img.shields.io/cocoapods/l/Debugo.svg?style=flat)](https://cocoapods.org/pods/Debugo)
[![Platform](https://img.shields.io/cocoapods/p/Debugo.svg?style=flat)](https://cocoapods.org/pods/Debugo)

Debugo 是一款致力于 iOS Debugging 的实用工具，集成和启用都非常简单。以 Debug 为宗旨，自然要做到尽量简单，要是出现因为 Debug 工具而导致 Bug 的情况，那就和初衷背道而驰了。后续应该还会加入一些新的功能，不过都会建立在硬需求的基础之上~

- [x] **方便** 一行代码即可启用
- [x] **安全** 内部做了控制，仅在 **DEBUG** 模式可以启用，携带上线无压力
- [x] **灵活** 可执行各种自定义功能代码或者跳转自定义页面

## Features

- [x] 添加测试代码，从悬浮列表点击调用
- [x] 辅助实现一建登陆，辅助存储登陆数据
- [x] 长按 Debug Bubble 启用 `UIDebuggingInformationOverlay`
- [x] 手机查看沙盒文件，Budle 文件，可利用 AirDrop 分享
- [x] 列出 Bundle 信息、设备信息、Build 信息、Git 信息 (需添加脚本文件)
- [x] 监控帧率 FPS
- [x] 监控手势触摸

## Snapshot

![](https://raw.githubusercontent.com/ripperhe/Resource/master/20180930/debugo.gif)

## Example

克隆或下载仓库到本地，进入到 Example/Debugo-Example-ObjectiveC 文件夹，执行 `pod install` 之后运行即可。

## Requirements

iOS 8.0+

## Dependency

本框架内部借鉴了很多框架，但是真正依赖的只有一个框架：

* [FMDB (>= 2.7.2)](https://github.com/ccgus/fmdb)

## Installation

本仓库支持 CocoaPods 安装，在工程的 Podfile 文件添加如下代码：

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
	pod 'Debugo',
end
```

## Usage For Objective-C

导入头文件

```objectivec
#import <Debugo/Debugo.h>
```

启用

```objectivec
[Debugo fireWithConfiguration:^(DGConfiguration * _Nonnull configuration) {
    // 设置 configuration 的属性，定制你的需求
}];
```

关闭

```objectivec
[Debugo stop];
```

[更多详细的使用方法可进入该页面查看 🚀](https://ripperhe.com/Debugo/#/Guide/quick-start)

## Thanks

开发框架的灵感，以及一些现成的代码很多都源于 GitHub 网站上的开源框架，感谢以下项目的所有者：

* [YYKit](https://github.com/ibireme/YYKit)
* [FTPopOverMenu](https://github.com/liufengting/FTPopOverMenu)
* [Alpha](https://github.com/Legoless/Alpha)
* [FileBrowser](https://github.com/marmelroy/FileBrowser)
* [GetGitInfo](https://github.com/y500/GetGitInfo)
* [DebuggingOverlay](https://gist.github.com/IMcD23/1fda47126429df43cc989d02c1c5e4a0)
* [DatabaseVisual](https://github.com/YanPengImp/DatabaseVisual)
* ...

文章参考：

* <https://git-scm.com/docs/git-log/1.7.12.2>
* <https://stackoverflow.com/questions/6245570/how-to-get-the-current-branch-name-in-git>
* <https://stackoverflow.com/questions/448162/determine-device-iphone-ipod-touch-with-iphone-sdk/1561920#1561920>
* <http://ryanipete.com/blog/ios/swift/objective-c/uidebugginginformationoverlay/>
* <http://www.cocoawithlove.com/2008/12/ordereddictionary-subclassing-cocoa.html>
* ...

## Author

ripperhe, 453942056@qq.com

## License

Debugo 基于 MIT 协议，详细请查看 LICENSE 文件。
