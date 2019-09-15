//
//  DGConfiguration.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DGActionPluginConfiguration.h"
#import "DGFilePluginConfiguration.h"
#import "DGAccountPluginConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGConfiguration : NSObject

/// 配置指令模块
- (void)setupActionPlugin:(void (^)(DGActionPluginConfiguration *actionConfiguration))block;

/// 配置文件模块
- (void)setupFilePlugin:(void (^)(DGFilePluginConfiguration *fileConfiguration))block;

/// 配置自动登录工具
- (void)setupAccountPlugin:(void (^)(DGAccountPluginConfiguration *accountConfiguration))block;

@end

NS_ASSUME_NONNULL_END
