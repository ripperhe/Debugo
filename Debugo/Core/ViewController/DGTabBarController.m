//
//  DGTabBarController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGTabBarController.h"
#import "DGNavigationController.h"
#import "DGActionViewController.h"
#import "DGFileViewController.h"
#import "DGAppInfoViewController.h"
#import "DGSettingViewController.h"
#import "DGBase.h"

@interface DGTabBarController ()<UITabBarControllerDelegate>

@end

@implementation DGTabBarController

- (void)dealloc {
    NSLog(@"%@ %@", self, NSStringFromSelector(_cmd));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    self.view.backgroundColor = [UIColor blackColor];
    self.tabBar.tintColor = kDGHighlightColor;
    
    DGActionViewController *testVC = [[DGActionViewController alloc] initWithStyle:UITableViewStyleGrouped];
    testVC.navigationItem.title = @"Debugo";
    DGNavigationController *testNavigationVC = [[DGNavigationController alloc] initWithRootViewController:testVC];
    testNavigationVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Action" image:[DGBundle imageNamed:@"action"] tag:0];
    
    DGFileViewController *fileVC = [[DGFileViewController alloc] initWithStyle:UITableViewStyleGrouped];
    fileVC.navigationItem.title = @"File";
    DGNavigationController *fileNavigationVC = [[DGNavigationController alloc] initWithRootViewController:fileVC];
    fileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"File" image:[DGBundle imageNamed:@"finder"] tag:0];

    DGAppInfoViewController *appInfoVC = [[DGAppInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    appInfoVC.navigationItem.title = @"App";
    DGNavigationController *appInfoNavigationVC = [[DGNavigationController alloc] initWithRootViewController:appInfoVC];
    appInfoNavigationVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"App" image:[DGBundle imageNamed:@"app"] tag:0];
    
    DGSettingViewController *settingVC = [[DGSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    settingVC.navigationItem.title = @"Setting";
    DGNavigationController *settingNavigationVC = [[DGNavigationController alloc] initWithRootViewController:settingVC];
    settingNavigationVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Setting" image:[DGBundle imageNamed:@"setting"] tag:0];
    
    self.viewControllers = @[testNavigationVC, fileNavigationVC, appInfoNavigationVC, settingNavigationVC];
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kDGHighlightColor} forState:UIControlStateSelected];
        [obj.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.572549 green:0.572549 blue:0.572549 alpha:1.0]} forState:UIControlStateNormal];
    }];
}

@end
