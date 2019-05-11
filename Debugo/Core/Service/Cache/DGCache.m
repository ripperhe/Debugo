//
//  DGCache.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGCache.h"
#import "DGAssistant.h"

NSString * const kDGSettingIsShowBottomBarWhenPushed = @"kDGSettingIsShowBottomBarWhenPushed";
NSString * const kDGSettingIsOpenFPS = @"kDGSettingIsOpenFPS";
NSString * const kDGSettingIsShowTouches = @"kDGSettingIsShowTouches";

@interface DGCache()

// sandbox
@property (nonatomic, copy) NSString *debugoPath;
@property (nonatomic, strong) DGPlister *settingPlister;
@property (nonatomic, strong) DGPlister *accountPlister;

@end

@implementation DGCache

static DGCache *_instance;
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
        
        // build info plister (从 bundle 中获取)
        NSString *buildInfoPlistPath = [[NSBundle mainBundle] pathForResource:@"com.ripperhe.debugo.build.info" ofType:@"plist"];
        if (buildInfoPlistPath.length) {
            _instance->_buildInfoPlister = [[DGPlister alloc] initWithFilePath:buildInfoPlistPath readonly:YES];
        }
    });
    return _instance;
}

#pragma mark - getter
- (NSString *)debugoPath {
    if (!_debugoPath) {
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *debugoPath = [cachePath stringByAppendingPathComponent:@"com.ripperhe.debugo"];
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:debugoPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSAssert(0, @"DGCache: 创建缓存文件文件夹失败");
        }
        _debugoPath = debugoPath;
    }
    return _debugoPath;
}

- (DGPlister *)settingPlister {
    if (!_settingPlister) {
        NSString *settingPath = [self.debugoPath stringByAppendingPathComponent:@"com.ripperhe.debugo.setting.plist"];
        _settingPlister = [[DGPlister alloc] initWithFilePath:settingPath readonly:NO];
    }
    return _settingPlister;
}

- (DGPlister *)accountPlister {
    if (!_accountPlister) {
        NSString *accountPath = nil;
        if (DGAssistant.shared.configuration.accountEnvironmentIsBeta) {
            accountPath = [self.debugoPath stringByAppendingPathComponent:@"com.ripperhe.debugo.account.beta.plist"];
        }else{
            accountPath = [self.debugoPath stringByAppendingPathComponent:@"com.ripperhe.debugo.account.official.plist"];
        }
        
        _accountPlister = [[DGPlister alloc] initWithFilePath:accountPath readonly:NO];
    }
    return _accountPlister;
}


@end
