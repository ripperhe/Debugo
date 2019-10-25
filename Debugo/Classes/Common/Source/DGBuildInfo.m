//
//  DGBuildInfo.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/25.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGBuildInfo.h"
#import "DGPlister.h"

@implementation DGBuildInfo

static DGBuildInfo *_instance;
+ (instancetype)shared {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        [_instance setup];
    });
    return _instance;
}

- (void)setup {
    self.configURL = @"https://github.com/ripperhe/Debugo/blob/master/docs/build-info.md";
    
    /**
     Build info plist（存储在 bundle 中）以下为所有 key 值:
     * ScriptVersion                    脚本版本
     * PlistUpdateTimestamp             plist 文件更新时间（build 时间）
     * BuildConfiguration               编译配置
     * ComputerUser                     编译包的电脑 当前用户名
     * ComputerUUID                     编译包的电脑 UUID
     * GitEnable                        编译包的电脑 是否安装 git
     * GitBranch                        当前 git 分支
     * GitLastCommitAbbreviatedHash     最后一次提交的缩写 hash
     * GitLastCommitUser                最后一次提交的用户
     * GitLastCommitTimestamp           最后一次提交的时间
     * CocoaPodsLockFileExist           是否拷贝了 Podfile.lock 文件
     * CocoaPodsLockFileName            Podfile.lock 文件名
     */

    // build info plister (从 bundle 中获取)
    NSString *buildInfoPlistPath = [[NSBundle mainBundle] pathForResource:@"com.ripperhe.debugo.build.info" ofType:@"plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:buildInfoPlistPath]) {
        return;
    }
    DGPlister *plister = [[DGPlister alloc] initWithFilePath:buildInfoPlistPath readonly:YES];
    self.scriptVersion = [plister stringForKey:@"ScriptVersion"];
    self.plistUpdateTimestamp = [plister stringForKey:@"PlistUpdateTimestamp"];
    self.buildConfiguration = [plister stringForKey:@"BuildConfiguration"];
    self.computerUser = [plister stringForKey:@"ComputerUser"];
    self.computerUUID = [plister stringForKey:@"ComputerUUID"];
    self.gitEnable = [plister boolForKey:@"GitEnable"];
    self.gitBranch = [plister stringForKey:@"GitBranch"];
    self.gitLastCommitAbbreviatedHash = [plister stringForKey:@"GitLastCommitAbbreviatedHash"];
    self.gitLastCommitUser = [plister stringForKey:@"GitLastCommitUser"];
    self.gitLastCommitTimestamp = [plister stringForKey:@"GitLastCommitTimestamp"];
    self.cocoaPodsLockFileExist = [plister boolForKey:@"CocoaPodsLockFileExist"];
    self.cocoaPodsLockFileName = [plister stringForKey:@"CocoaPodsLockFileName"];

}

@end
