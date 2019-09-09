//
//  DGAccountPlugin.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGAccountPlugin.h"
#import "DGCache.h"
#import "DGQuickLoginViewController.h"

@interface DGAccountPlugin()

@property (nonatomic, strong, nullable) DGWindow *loginWindow;

@end

@implementation DGAccountPlugin

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

- (void)setupWithConfiguration:(DGAccountPluginConfiguration *)configuration {
    self.configuration = configuration;
    if (self.configuration.isProductionEnvironment) {
        self.currentCommonAccountArray = self.configuration.commonProductionAccounts;
    }else{
        self.currentCommonAccountArray = self.configuration.commonDevelopmentAccounts;
    }
}

- (void)reset {
    self.currentCommonAccountArray = nil;
    [self removeLoginWindow];
}

#pragma mark - getter

- (DGOrderedDictionary<NSString *,DGAccount *> *)temporaryAccountDic {
    if (!_temporaryAccountDic) {
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
        _temporaryAccountDic = accountDic;
    }
    return _temporaryAccountDic;
}

#pragma mark -

- (void)addAccount:(DGAccount *)account {
    DGAccount *newAccount = account;
    if (!newAccount.isValid) return;
    
    for (DGAccount *account in self.currentCommonAccountArray) {
        if ([newAccount.username isEqualToString:account.username] && [newAccount.password isEqualToString:account.password]) {
            // 重复账号 忽略
            return;
        }
    }
    
    // 在 permanent 中没有重复账号，添加到 temporary
    [self.temporaryAccountDic setObject:newAccount forKey:newAccount.username];
    // 缓存到本地
    [DGCache.shared.accountPlister setObject:newAccount.password forKey:newAccount.username];
}

#pragma mark - login view controller
- (void)showLoginWindow {
    if (!self.loginWindow) {
        // create
        DGQuickLoginViewController *loginVC = [[DGQuickLoginViewController alloc] init];
        DGWindow *window = [[DGWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.name = @"Login Window";
        window.rootViewController = loginVC;
        window.windowLevel = 1000000;
        self.loginWindow = window;
        
        // show
        [self.loginWindow setHidden:NO];
    }
    [self.loginWindow setHidden:NO];
}

- (void)removeLoginWindow {
    [self.loginWindow destroy];
    self.loginWindow = nil;
}

@end
