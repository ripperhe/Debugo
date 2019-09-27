//
//  DGNavigationController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGNavigationController.h"
#import "DGCommon.h"

@interface DGNavigationController ()

@end

@implementation DGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTintColor:kDGHighlightColor];
    // [self.navigationBar setTranslucent:NO];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 下一个控制器被推出来的时候隐藏 tabBar
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 去掉返回按钮文字
    UIViewController *currentViewController = self.topViewController;
    if (currentViewController) {
        currentViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
