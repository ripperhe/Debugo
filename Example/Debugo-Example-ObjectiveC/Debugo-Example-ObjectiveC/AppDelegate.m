//
//  AppDelegate.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/2/20.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "AppDelegate.h"
#import "Debugo.h"
#import "DGFilePath.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DGDebugo fireWithConfiguration:^(DGConfiguration * _Nonnull configuration) {
        
        configuration.commonActions = @[
                                        [DGAction actionWithTitle:@"Log Top ViewController 😘" autoClose:YES handler:^(DGAction *action) {
                                            UIViewController *vc = DGDebugo.topViewController;
                                            NSLog(@"%@", vc);
                                        }],
                                        [DGAction actionWithTitle:@"Log All Window 🧐" autoClose:YES handler:^(DGAction *action) {
                                            NSArray *array = [DGDebugo getAllWindows];
                                            NSLog(@"%@", array);
                                        }],
                                        ];
        
        configuration.accountConfiguration.isProductionEnvironment = YES;
        configuration.accountConfiguration.commonDevelopmentAccounts = @[
                                             [DGAccount accountWithUsername:@"jintianyoudiantoutong@qq.com" password:@"dasinigewangbadan🤣"],
                                             [DGAccount accountWithUsername:@"wozhendeyoudianxinfan@qq.com" password:@"niyoubenshizaishuoyiju🧐"],
                                             [DGAccount accountWithUsername:@"kanshenmekan@gmail.com" password:@"meijianguoma😉"],
                                             [DGAccount accountWithUsername:@"woshikaiwanxiaode@163.com" password:@"zhendezhende😨"],
                                             ];
        configuration.accountConfiguration.commonProductionAccounts = @[
                                                 [DGAccount accountWithUsername:@"wolaile@gmail.com" password:@"😴wozouleoubuwoshuile"],
                                                 [DGAccount accountWithUsername:@"woshixianshangzhanghao@qq.com" password:@"😉wojiuwennipabupa"],
                                                 [DGAccount accountWithUsername:@"xianshangdeniubiba@qq.com" password:@"😍hahahabixude"],
                                                 ];
        configuration.accountConfiguration.execLoginCallback = ^(DGAccount * _Nonnull account) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            
            UIViewController *currentVC = [DGDebugo topViewController];
            
            // 假设需要在这两个页面自动登录
            Class DebugoVCClass = NSClassFromString(@"ViewController");
            Class LoginVCClass = NSClassFromString(@"LoginViewController");
            
            if (DebugoVCClass && [currentVC isMemberOfClass:DebugoVCClass]) {
                // go to login vc
                [currentVC performSelector:@selector(clickGoToTestLogin) withObject:nil];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // run login method
                    UIViewController *vc = [DGDebugo topViewController];
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
        };
        
        
        configuration.fileConfiguration.shortcutForDatabasePaths = @[
                                                  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject,
                                                  [NSBundle mainBundle].bundlePath,
                                                  [DGFilePath.documentsDirectory stringByAppendingPathComponent:@"xx.sqlite"],
                                                  ];
        
        configuration.fileConfiguration.shortcutForAnyPaths = @[
                                             NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject,
                                             DGFilePath.userDefaultsPlistFilePath,
                                             ];
        
        // 自定义显示数据库文件时的宽高
//        configuration.fileConfiguration.databasePreviewConfigurationFetcher = ^DGDatabasePreviewConfiguration * _Nullable(NSURL * _Nonnull databaseURL) {
//            if ([databaseURL.lastPathComponent isEqualToString:@"picooc.production.sqlite"]) {
//                DGDatabasePreviewConfiguration *config = [DGDatabasePreviewConfiguration new];
//                [config setSpecialColumnWidthDictionary:@{
//                                                          @"pk_createTime":@200
//                                                          }
//                                               forTable:@"error_info"];
//                return config;
//            }
//            return nil;
//        };
    }];
    
    [DGDebugo addActionWithTitle:@"xxx" handler:^(DGAction * _Nonnull action) {
        NSLog(@"123");
    }];
    
//    [DGDebugo addActionForUser:@"ripper" title:@"今天吃啥啊？" autoClose:YES handler:^(DGAction * _Nonnull action, UIViewController * _Nonnull actionVC) {
//        DGLog(@"不知道啊...");
//    }];
//
//    [DGDebugo addActionForUser:@"user1" title:@"来个弹窗 🤣" autoClose:NO handler:^(DGAction *action, UIViewController *actionVC) {
//        UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"Ha Ha" message:@"mei shen me, wo jiu xiang xiao yi xia~" preferredStyle:UIAlertControllerStyleAlert];
//        [alerController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"mei shen me, wo zhi dao le!");
//        }]];
//        [actionVC presentViewController:alerController animated:YES completion:nil];
//    }];
//
//    [DGDebugo addActionForUser:@"user2" title:@"push 新控制器 👉" autoClose:NO handler:^(DGAction *action, UIViewController *actionVC) {
//        UIViewController *vc = [UIViewController new];
//        vc.view.backgroundColor = [UIColor orangeColor];
//        [actionVC.navigationController pushViewController:vc animated:YES];
//    }];
//
//
//    [DGDebugo addActionWithTitle:@"log windows" handler:^(DGAction *action, UIViewController *actionVC) {
//        DGLog(@"\n%@", [UIApplication sharedApplication].windows);
//        [[UIApplication sharedApplication].windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            DGLog(@"%f", obj.windowLevel);
//        }];
//    }];
//
//    [DGDebugo addActionWithTitle:@"screen bounds" handler:^(DGAction * _Nonnull action, UIViewController * _Nonnull actionViewController) {
//        DGLog(@"%@", NSStringFromCGRect([UIScreen mainScreen].bounds));
//    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"中文 中文 中文" forKey:@"Test UserDefaults"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self internalDevelop];
    
    return YES;
}

- (void)internalDevelop {
}


@end
