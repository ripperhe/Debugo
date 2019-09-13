//
//  DGCache.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGPlister.h"

extern NSString * const kDGSettingIsShowBottomBarWhenPushed;
extern NSString * const kDGSettingIsOpenFPS;
extern NSString * const kDGSettingIsShowTouches;

@interface DGCache : NSObject

/// 缓存文件夹
@property (nonatomic, copy) NSString *debugoPath;

/// 设置的plist文件
@property (nonatomic, strong, readonly) DGPlister *settingPlister;

/// 缓存账号的plist文件
@property (nonatomic, strong, readonly) DGPlister *accountPlister;

+ (instancetype)shared;

@end
