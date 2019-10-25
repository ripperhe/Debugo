//
//  DGBuildInfo.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/25.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGBuildInfo : NSObject

/// 配置脚本的网址
@property (nonatomic, copy) NSString *configURL;
/// 脚本版本
@property (nonatomic, copy) NSString *scriptVersion;
/// plist 文件更新时间（build 时间）
@property (nonatomic, copy) NSString *plistUpdateTimestamp;
/// 编译配置
@property (nonatomic, copy) NSString *buildConfiguration;
/// 编译包的电脑 当前用户名
@property (nonatomic, copy) NSString *computerUser;
/// 编译的电脑的UUID
@property (nonatomic, copy) NSString *computerUUID;
/// 编译包的电脑 是否安装 git
@property (nonatomic, assign) BOOL gitEnable;
/// 当前 git 分支
@property (nonatomic, copy) NSString *gitBranch;
/// 最后一次提交的缩写 hash
@property (nonatomic, copy) NSString *gitLastCommitAbbreviatedHash;
/// 最后一次提交的用户
@property (nonatomic, copy) NSString *gitLastCommitUser;
/// 最后一次提交的时间
@property (nonatomic, copy) NSString *gitLastCommitTimestamp;
/// 是否拷贝了 Podfile.lock 文件
@property (nonatomic, assign) BOOL cocoaPodsLockFileExist;
/// Podfile.lock 文件名
@property (nonatomic, copy) NSString *cocoaPodsLockFileName;

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
