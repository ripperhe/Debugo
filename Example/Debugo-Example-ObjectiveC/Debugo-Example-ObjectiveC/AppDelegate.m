//
//  AppDelegate.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/2/20.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "AppDelegate.h"
#import "Debugo.h"

@interface AppDelegate ()<DGDebugoDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    DGDebugo.shared.delegate = self;
    [DGDebugo fireWithConfiguration:^(DGConfiguration * _Nonnull configuration) {
        
        configuration.commonTestActions = @[
                                            [DGTestAction actionWithTitle:@"Log Top ViewController 😘" autoClose:YES handler:^(DGTestAction *action, UIViewController *actionVC) {
                                                UIViewController *vc = [DGDebugo topViewControllerForWindow:nil];
                                                NSLog(@"%@", vc);
                                            }],
                                            [DGTestAction actionWithTitle:@"Log All Window 🧐" autoClose:YES handler:^(DGTestAction *action, UIViewController *actionVC) {
                                                NSArray *array = [DGDebugo getAllWindows];
                                                NSLog(@"%@", array);
                                            }],
                                            ];
        
        
        configuration.needLoginBubble = YES;
        configuration.haveLoggedIn = NO;
        configuration.accountEnvironmentIsBeta = YES;
        configuration.commonBetaAccounts = @[
                                             [DGAccount accountWithUsername:@"jintianyoudiantoutong@qq.com" password:@"dasinigewangbadan🤣"],
                                             [DGAccount accountWithUsername:@"wozhendeyoudianxinfan@qq.com" password:@"niyoubenshizaishuoyiju🧐"],
                                             [DGAccount accountWithUsername:@"kanshenmekan@gmail.com" password:@"meijianguoma😉"],
                                             [DGAccount accountWithUsername:@"woshikaiwanxiaode@163.com" password:@"zhendezhende😨"],
                                             ];
        configuration.commonOfficialAccounts = @[
                                                 [DGAccount accountWithUsername:@"wolaile@gmail.com" password:@"😴wozouleoubuwoshuile"],
                                                 [DGAccount accountWithUsername:@"woshixianshangzhanghao@qq.com" password:@"😉wojiuwennipabupa"],
                                                 [DGAccount accountWithUsername:@"xianshangdeniubiba@qq.com" password:@"😍hahahabixude"],
                                                 ];
        
        
        configuration.shortcutForDatabaseURLs = @[
                                                  [NSURL URLWithString:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject],
                                                  [NSURL URLWithString:[NSBundle mainBundle].bundlePath],
                                                  ];
        NSString *libDirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        NSString *userDefaultPath = [NSString stringWithFormat:@"%@/Preferences/%@.plist", libDirectory, [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleIdentifier"]];
        configuration.shortcutForAnyURLs = @[[NSURL fileURLWithPath:userDefaultPath]];
        
    }];
    
    [DGDebugo addTestActionForUser:@"ripper" title:@"今天吃啥啊？" autoClose:YES handler:^(DGTestAction * _Nonnull action, UIViewController * _Nonnull actionVC) {
        DGLog(@"不知道啊...");
    }];
    
    [DGDebugo addTestActionForUser:@"user1" title:@"来个弹窗 🤣" autoClose:NO handler:^(DGTestAction *action, UIViewController *actionVC) {
        UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"Ha Ha" message:@"mei shen me, wo jiu xiang xiao yi xia~" preferredStyle:UIAlertControllerStyleAlert];
        [alerController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"mei shen me, wo zhi dao le!");
        }]];
        [actionVC presentViewController:alerController animated:YES completion:nil];
    }];
    
    [DGDebugo addTestActionForUser:@"user2" title:@"push 新控制器 👉" autoClose:NO handler:^(DGTestAction *action, UIViewController *actionVC) {
        UIViewController *vc = [UIViewController new];
        vc.view.backgroundColor = [UIColor orangeColor];
        [actionVC.navigationController pushViewController:vc animated:YES];
    }];
    
    
    [DGDebugo addTestActionWithTitle:@"log windows" handler:^(DGTestAction *action, UIViewController *actionVC) {
        DGLog(@"\n%@", [UIApplication sharedApplication].windows);
        [[UIApplication sharedApplication].windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DGLog(@"%f", obj.windowLevel);
        }];
    }];
    
    [DGDebugo addTestActionWithTitle:@"screen bounds" handler:^(DGTestAction * _Nonnull action, UIViewController * _Nonnull actionViewController) {
        DGLog(@"%@", NSStringFromCGRect([UIScreen mainScreen].bounds));
    }];
    
    return YES;
}

#pragma mark - DGDebugoDelegate
- (void)debugoLoginAccount:(DGAccount *)account
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    UIViewController *currentVC = [DGDebugo topViewControllerForWindow:nil];
    
    // 假设需要在这两个页面自动登录
    Class DebugoVCClass = NSClassFromString(@"ViewController");
    Class LoginVCClass = NSClassFromString(@"LoginViewController");
    
    if (DebugoVCClass && [currentVC isMemberOfClass:DebugoVCClass]) {
        // go to login vc
        [currentVC performSelector:@selector(clickGoToTestLogin) withObject:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // run login method
            UIViewController *vc = [DGDebugo topViewControllerForWindow:nil];
            if ([vc isKindOfClass:LoginVCClass]) {
                [vc performSelector:@selector(sendLoginRequestWithAccount:password:) withObject:account.username withObject:account.password];
            }
        });
    }else if (LoginVCClass && [currentVC isMemberOfClass:LoginVCClass]) {
        // run login method
        [currentVC performSelector:@selector(sendLoginRequestWithAccount:password:) withObject:account.username withObject:account.password];
    }else{
        NSLog(@"Can't quick login at here.");
    }
    
#pragma clang diagnostic pop
}

// 自定义 test action 页面 table header; 可以用来显示当前登陆的 App 用户 ID 等等~
- (UIView *)debugoTestActionViewControllerTableHeaderView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 60)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0];
    label.textColor = UIColor.whiteColor;
    label.text = @"☄️ amor fati";
    return label;
}

// 自定义显示数据库文件时的宽高
- (DGDatabaseUIConfig *)debugoDatabaseUIConfigForDatabaseURL:(NSURL *)databaseURL
{
    if ([databaseURL.path.lastPathComponent isEqualToString:@"picooc.production.sqlite"]) {
        DGDatabaseTableUIConfig *errorTableConfig = [DGDatabaseTableUIConfig new];
        errorTableConfig.specialWidthForColumn = @{
                                                   @"pk_createTime":@(160.0),
                                                   @"pk_updateTime":@(160.0),
                                                   @"productWxSn":@(180.0),
                                                   @"productMac":@(160.0),
                                                   @"productSerialNum":@(180.0),
                                                   @"productWxUrl":@(180.0),
                                                   };
        
        DGDatabaseUIConfig *config = [DGDatabaseUIConfig new];
        config.specialConfigForTable = @{
                                         @"error_info":errorTableConfig,
                                         };
        return config;
    }
    return nil;
}

@end
