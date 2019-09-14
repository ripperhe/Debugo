//
//  DGConfiguration.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DGAction.h"
#import "DGAccountPluginConfiguration.h"
#import "DGFilePluginConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGConfiguration : NSObject<NSCopying>

/** 指令模块，公用 action */
@property (nullable, nonatomic, strong) NSArray <DGAction *>*commonActions;
/** 文件模块配置 */
@property (nonatomic, strong, readonly) DGFilePluginConfiguration *fileConfiguration;
/** 登陆模块配置 */
@property (nonatomic, strong, readonly) DGAccountPluginConfiguration *accountConfiguration;

///------------------------------------------------
/// setting 以下设置均可在设置页面开启; 如需强制开启，可在代码中设置
///------------------------------------------------

/** 是否在 push 时显示 tabBar; 默认为 NO */
@property (nonatomic, assign) BOOL isShowBottomBarWhenPushed;
/** 是否在 debug bubble 显示 FPS; 默认为 NO */
@property (nonatomic, assign) BOOL isOpenFPS;
/** 是否显示 touch 效果; 默认为 NO */
@property (nonatomic, assign) BOOL isShowTouches;

@end

NS_ASSUME_NONNULL_END
