
<p align="center">
  <img src="https://raw.githubusercontent.com/ripperhe/Debugo/master/docs/_media/debugo.png" />
</p>

# Debugo

[![Version](https://img.shields.io/cocoapods/v/Debugo.svg?style=flat)](https://cocoapods.org/pods/Debugo)
[![License](https://img.shields.io/cocoapods/l/Debugo.svg?style=flat)](https://cocoapods.org/pods/Debugo)
[![Platform](https://img.shields.io/cocoapods/p/Debugo.svg?style=flat)](https://cocoapods.org/pods/Debugo)

Debugo 是一款致力于 iOS Debugging 的实用工具，集成和启用都非常简单。以 Debug 为宗旨，自然要做到尽量简单，尽量避免 Debug 工具而导致 Bug 的情况。后续应该还会加入一些新的功能~

- [x] **方便** 一行代码即可启用
- [x] **安全** 内部做了控制，仅在 **DEBUG** 模式可以启用，携带上线无压力
- [x] **灵活** 可添加自定义指令和工具

## Features

* [x] 指令模块
	* 快捷添加代码块，点击指令列表的 `Cell` 执行
	* 支持多人协作，根据 User 自动优先显示当前用户的指令
* [x] 文件模块
	* 支持查看沙盒和 Bundle 的文件
	* 支持预览数据库及其他大部分文件
	* 支持利用 `AirDrop` 分享文件
	* 支持设置文件捷径，快速直达经常查看的文件
* [x] 工具模块
	* App 信息工具
		* 查看 Bundle 信息
		* 查看设备信息
		* 查看编译信息（[需配置脚本](https://ripperhe/Debugo/docs/build-info)）
	* 快速登录工具
		* 简单配置之后，可一键登录
		* 调用一句代码即可缓存账号
	* Apple 内部工具
 		* 苹果内部工具 `UIDebuggingInformationOverlay`
		* [一些使用方法](http://ryanipete.com/blog/ios/swift/objective-c/uidebugginginformationoverlay/)
	* 触摸监听
		* 监听手势触摸
		* 用于手机录屏时能够看到手指的操作

## Snapshot

![](https://raw.githubusercontent.com/ripperhe/Resource/master/20180930/debugo.gif)

## Example

克隆或下载仓库到本地，进入到 Example/Debugo-Example-ObjectiveC 文件夹，打开 `Debugo-Example-ObjectiveC.xcworkspace` 运行即可。

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
    // 配置 configuration，定制你的需求
}];
```

更多详细的使用方法可下载 Demo 查看

## Thanks

开发框架的灵感，以及一些现成的代码很多都源于 GitHub 网站上的开源框架，感谢以下项目和文章的作者：

* [Alpha](https://github.com/Legoless/Alpha)
* [FileBrowser](https://github.com/marmelroy/FileBrowser)
* [GetGitInfo](https://github.com/y500/GetGitInfo)
* [DebuggingOverlay](https://gist.github.com/IMcD23/1fda47126429df43cc989d02c1c5e4a0)
* [DatabaseVisual](https://github.com/YanPengImp/DatabaseVisual)
* <https://stackoverflow.com/questions/448162/determine-device-iphone-ipod-touch-with-iphone-sdk/1561920#1561920>
* <http://ryanipete.com/blog/ios/swift/objective-c/uidebugginginformationoverlay/>
* <http://www.cocoawithlove.com/2008/12/ordereddictionary-subclassing-cocoa.html>
* ...

## Author

ripperhe, 453942056@qq.com

## License

Debugo 基于 MIT 协议，详细请查看 LICENSE 文件。
