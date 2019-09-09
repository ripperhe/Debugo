//
//  DGAccountManager.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGAccountManager.h"
#import "DGCache.h"
#import "DGQuickLoginViewController.h"

@interface DGAccountManager()<DGSuspensionBubbleDelegate>

@property (nonatomic, weak) DGSuspensionBubble *loginBubble;
@property (nonatomic, strong, nullable) DGWindow *loginWindow;

@end

@implementation DGAccountManager

static DGAccountManager *_instance;
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

- (void)setupWithConfiguration:(DGAccountConfiguration *)configuration {
    self.configuration = configuration;
    if (self.configuration.isProductionEnvironment) {
        self.currentCommonAccountArray = self.configuration.commonProductionAccounts;
    }else{
        self.currentCommonAccountArray = self.configuration.commonDevelopmentAccounts;
    }
    
    if (self.configuration.needLoginBubble && (self.configuration.haveLoggedIn == NO)) {
        [self showLoginBubble];
    }
}

- (void)reset {
    self.currentCommonAccountArray = nil;
    [self removeLoginBubble];
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

#pragma mark - login bubble
- (void)showLoginBubble {
    if (self.loginBubble) {
        if (!self.loginBubble.rootViewController) {
            NSLog(@"💥💥💥💥💥💥💥💥 woca 出大事儿了，一定是 UIDxxx 引用了我的 Window ！将就用吧，不就是多开辟一点内存嘛 🤣 ");
            [self.loginBubble setHidden:YES];
            self.loginBubble = nil;
        }else{
            [self.loginBubble setHidden:NO];
            return;
        }
    }
    
    DGSuspensionBubbleConfig *config = [DGSuspensionBubbleConfig new];
    config.buttonType = UIButtonTypeSystem;
    config.leanStateAlpha = .9;
    config.showLongPressAnimation = NO;
    
    DGSuspensionBubble *loginBubble = [[DGSuspensionBubble alloc] initWithFrame:CGRectMake(400, kDGScreenH - (165 + 55 + kDGBottomSafeMargin), 55, 55)
                                                                         config:config];
    loginBubble.name = @"Login Bubble";
    loginBubble.dg_delegate = self;
    [loginBubble.button setTintColor:[UIColor whiteColor]];
    loginBubble.button.backgroundColor = [UIColor colorWithRed:0.15 green:0.74 blue:0.30 alpha:1.00];
    [loginBubble.button setImage:[DGBundle imageNamed:@"login_bubble"] forState:UIControlStateNormal];
    [loginBubble show];
    self.loginBubble = loginBubble;
}

- (void)removeLoginBubble {
    [self.loginBubble removeFromScreen];
}

#pragma mark - login view controller
- (void)removeLoginWindow {
    [self.loginWindow destroy];
    self.loginWindow = nil;
}

#pragma mark - DGSuspensionBubbleDelegate
- (void)suspensionBubbleClick:(DGSuspensionBubble *)suspensionBubble {
    if (self.loginWindow) {
        // remove
        [self removeLoginWindow];
    }else{
        // create
        DGQuickLoginViewController *loginVC = [[DGQuickLoginViewController alloc] init];
        DGWindow *window = [[DGWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.name = @"Login Window";
        window.rootViewController = loginVC;
        window.windowLevel = 1000000;
        self.loginWindow = window;
        
        // show
//        [self closeDebugWindow];
        [self.loginWindow setHidden:NO];
    }
}


@end
