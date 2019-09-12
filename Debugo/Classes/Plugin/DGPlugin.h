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

/// 组件对应控制器
+ (Class)pluginViewControllerClass;

/// 开关
@property (class, nonatomic, assign) BOOL pluginSwitch;

@end

// 所有组件方法均用于子类重写(所有方法可不重写)，无需调用父类
@interface DGPlugin : NSObject<DGPluginProtocol>

@end

NS_ASSUME_NONNULL_END
