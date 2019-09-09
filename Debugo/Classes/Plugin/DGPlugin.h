//
//  DGPlugin.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/9.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DGPluginProtocol <NSObject>

/// 名称
+ (NSString *)pluginName;

/// 图像
+ (UIImage *)pluginImage;

/// 初始配置配置
+ (void)pluginSetupWithConfiguration:(id)configuration;

/// 组件对应控制器
+ (Class)pluginViewControllerClass;

/// 是否可以启用
+ (BOOL)pluginCanFire;

/// 是否已经启用
+ (BOOL)pluginIsFire;

/// 触发
+ (void)pluginFire;

/// 停用
+ (void)pluginStop;

/// 关闭组件相关window
+ (void)pluginCloseWindow;

@end

// 所有组件方法均用于子类重写(所有方法可不重写)，无需调用父类
@interface DGPlugin : NSObject<DGPluginProtocol>

@end

NS_ASSUME_NONNULL_END
