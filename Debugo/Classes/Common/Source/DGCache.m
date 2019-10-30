//
//  DGCache.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGCache.h"
#import "DGEntrance.h"
#import "DGAccountPlugin.h"

@interface DGCache()

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

- (DGPlister *)accountPlister {
    if (!_accountPlister) {
        NSString *accountPath = nil;
        if (DGAccountPlugin.shared.configuration.isProductionEnvironment) {
            accountPath = [self.debugoPath stringByAppendingPathComponent:@"com.ripperhe.debugo.account.production.plist"];
        }else{
            accountPath = [self.debugoPath stringByAppendingPathComponent:@"com.ripperhe.debugo.account.development.plist"];
        }
        
        _accountPlister = [[DGPlister alloc] initWithFilePath:accountPath readonly:NO];
    }
    return _accountPlister;
}


@end
