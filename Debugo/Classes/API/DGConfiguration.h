//
//  DGConfiguration.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DGActionPlugin.h"
#import "DGFilePlugin.h"
#import "DGAppInfoPlugin.h"
#import "DGAccountPlugin.h"
#import "DGApplePlugin.h"
#import "DGTouchPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGConfiguration : NSObject

/// 自定义悬浮球的长按事件，可用于某些需要快捷操作的事情（点击事件是开启和关闭 Debug Window）
- (void)setupBubbleLongPressAction:(void (^)(void))block;

/// 配置指令模块
- (void)setupActionPlugin:(void (^)(DGActionPluginConfiguration *actionConfiguration))block;

/// 配置文件模块
- (void)setupFilePlugin:(void (^)(DGFilePluginConfiguration *fileConfiguration))block;

/// 配置自动登录工具
- (void)setupAccountPlugin:(void (^)(DGAccountPluginConfiguration *accountConfiguration))block;

/// 添加自定义工具，需继承自 DGPlugin 或遵守 DGPluginProtocol 协议
- (void)addCustomPlugin:(Class<DGPluginProtocol>)plugin;

/// 将工具放到 tabBar 上；默认是 DGActionPlugin
/// 目前支持 DGActionPlugin DGFilePlugin DGAppInfoPlugin DGAppInfoPlugin
/// 以及实现了pluginViewControllerClass 的自定义插件
- (void)putPluginsToTabBar:(nullable NSArray<Class<DGPluginProtocol>> *)plugins;

@end

NS_ASSUME_NONNULL_END
