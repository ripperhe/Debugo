# 快速开始

从 UI 上来看，Debugo 有两个悬浮球和两个悬浮页面组成，主要的悬浮球为 Debug Bubble，点击可显示 Debug 信息悬浮页面，包括执行测试条目查看 Bundle 信息等功能；另一个悬浮球为 Login Bubble，用于实现快速登陆，点击展示账户列表悬浮页面，选中账户实现快速登陆~

## 安装

本仓库支持 CocoaPods 安装，在工程的 Podfile 文件添加如下代码：

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
	pod 'Debugo',
end
```

## 使用

导入头文件

```objectivec
#import <Debugo/DebugoHeader.h>
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

## Configuration 配置的详细参数

### User 设置

* `debugoUserArray ` 使用本框架的所有用户名字和其 Mac 电脑 UUID

### Setting 相关设置

以下均可在设置页面开启，如果需要强制开启，则直接在启用时的 block 中配置

* `isFullScreen` 是否开启全屏
* `isOpenFPS` 是否开启监控 FPS
* `isShowTouches` 是否监控手势触摸
* `isOpenSandboxUploader` 是否开启沙盒 uploader 服务
* `isOpenSandboxDAVServer` 是否开启沙盒 DAV 服务

### Web Server 相关设置

以下为 web 服务的接口

* `sandboxUploaderPort` 沙盒文件 uploader 服务端口; 默认为 8082
* `sandboxDAVServerPort` 沙盒文件 DAV 服务端口; 默认为 8083

### Test Action 相关设置

以下设置和测试条目有关

* `permanentTestActionArray` 永远展示在测试列表的测试条目

### Quick Login 相关设置

以下设置与快速登陆有关

* `needLoginBubble` 是否需要快速登陆的 login bubble
* `hasLogined` 初始化 Debugo 时是否为登陆状态; 用于判断当前是否需要开启 login bubble
* `accountEnvironmentIsBeta` 当前的账号环境是否为测试环境；默认为测试环境
* `permanentBetaAccountArray` 永远展现在登陆账号里面的测试环境账号
* `permanentOfficialAccountArray` 永远展现在登陆账号里面的正式环境账号
