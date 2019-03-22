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

extern NSString * const kDGSettingIsFullScreen;
extern NSString * const kDGSettingIsOpenFPS;
extern NSString * const kDGSettingIsShowTouches;

@interface DGCache : NSObject

/**
 Build info plist（存在 bundle 中）以下为所有 key 值:
 * ScriptVersion                    脚本版本
 * PlistUpdateTimestamp             plist 文件更新时间（build 时间）
 * BuildConfiguration               编译配置
 * ComputerUser                     编译包的电脑 当前用户名
 * ComputerHostname                 编译包的电脑 hostname
 * ComputerUUID                     编译包的电脑 UUID
 * GitEnable                        编译包的电脑 是否安装 git
 * GitBranch                        当前 git 分支
 * GitLastCommitAbbreviatedHash     最后一次提交的缩写 hash
 * GitLastCommitUser                最后一次提交的用户
 * GitLastCommitTimestamp           最后一次提交的时间
 */
@property (nonatomic, strong, readonly) DGPlister *buildInfoPlister;

/** Setting plist:
 * kDGSettingIsFullScreen
 * kDGSettingIsOpenFPS
 * kDGSettingIsShowTouches
 */
@property (nonatomic, strong, readonly) DGPlister *settingPlister;

/** Account plist */
@property (nonatomic, strong, readonly) DGPlister *accountPlister;

+ (instancetype)shared;

@end
