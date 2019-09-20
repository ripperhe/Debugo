//
//  DGAccountPlugin.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGAccountPlugin.h"
#import "DGCache.h"
#import "DGAccountBackViewController.h"

@interface DGAccountPlugin()

@property (nonatomic, strong, nullable) DGWindow *loginWindow;

@end

@implementation DGAccountPlugin

+ (NSString *)pluginName {
    return @"快速登陆";
}

+ (UIImage *)pluginImage {
    return [DGBundle imageNamed:@"plugin_account"];
}

+ (BOOL)pluginSwitch {
    if ([[self shared] loginWindow] && [[self shared] loginWindow].hidden == NO) {
        return YES;
    }
    return NO;
}

+ (void)setPluginSwitch:(BOOL)pluginSwitch {
    if (pluginSwitch) {
        if (![[self shared] loginWindow]) {
            DGWindow *window = [[DGWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            window.name = @"Login Window";
            window.rootViewController = [DGAccountBackViewController new];
            window.windowLevel = 1000000;
            [[self shared] setLoginWindow:window];
            [window setHidden:NO];
        }
        [[[self shared] loginWindow] setHidden:NO];
    }else {
        if ([[self shared] loginWindow]) {
            [(DGAccountBackViewController *)[[self shared] loginWindow].rootViewController dismissWithAnimation:^{
                [[[self shared] loginWindow] destroy];
                [[self shared] setLoginWindow:nil];
            }];
        }
    }
}

#pragma mark -

static DGAccountPlugin *_instance;
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

- (DGAccountPluginConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [DGAccountPluginConfiguration new];
    }
    return _configuration;
}

- (NSArray<DGAccount *> *)currentCommonAccountArray {
    if(self.configuration.isProductionEnvironment) {
        return self.configuration.commonProductionAccounts;
    }else {
        return self.configuration.commonDevelopmentAccounts;
    }
}

- (void)addAccount:(DGAccount *)account {
    DGAccount *newAccount = account;
    if (!newAccount.isValid) return;
    
    for (DGAccount *account in self.currentCommonAccountArray) {
        if ([newAccount.username isEqualToString:account.username] && [newAccount.password isEqualToString:account.password]) {
            // 重复账号 忽略
            return;
        }
    }
    
    // 在共享账号中没有重复账号，添加到缓存账号中
    [self.cacheAccountDic setObject:newAccount forKey:newAccount.username];
    // 缓存到本地
    [DGCache.shared.accountPlister setObject:newAccount.password forKey:newAccount.username];
}

#pragma mark - getter

- (DGOrderedDictionary<NSString *,DGAccount *> *)cacheAccountDic {
    if (!_cacheAccountDic) {
        DGOrderedDictionary *accountDic = [DGOrderedDictionary dictionary];
        // 获取本地缓存
        NSDictionary *cacheAccount = [DGCache.shared.accountPlister read];
        NSArray *sortedKeys = [cacheAccount.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
            return [obj2 compare:obj1];
        }];
        [sortedKeys enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DGAccount *account = [DGAccount accountWithUsername:obj password:[cacheAccount objectForKey:obj]];
            if (account.isValid) {
                [accountDic setObject:account forKey:account.username];
            }
        }];
        _cacheAccountDic = accountDic;
    }
    return _cacheAccountDic;
}

@end
