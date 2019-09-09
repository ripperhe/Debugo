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
#import "DGPluginViewController.h"
#import "DGCommon.h"

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
    testVC.navigationItem.title = @"指令";
    DGNavigationController *testNavigationVC = [[DGNavigationController alloc] initWithRootViewController:testVC];
    testNavigationVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"指令" image:[DGBundle imageNamed:@"action"] tag:0];
    
    DGFileViewController *fileVC = [[DGFileViewController alloc] initWithStyle:UITableViewStyleGrouped];
    fileVC.navigationItem.title = @"文件";
    DGNavigationController *fileNavigationVC = [[DGNavigationController alloc] initWithRootViewController:fileVC];
    fileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"文件" image:[DGBundle imageNamed:@"file"] tag:0];
    
    DGPluginViewController *pluginVC = [DGPluginViewController new];
    pluginVC.navigationItem.title = @"工具";
    DGNavigationController *pluginNavigationVC = [[DGNavigationController alloc] initWithRootViewController:pluginVC];
    pluginVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"工具" image:[DGBundle imageNamed:@"file"] tag:0];
    
    self.viewControllers = @[testNavigationVC, fileNavigationVC, pluginNavigationVC];
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kDGHighlightColor} forState:UIControlStateSelected];
        [obj.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.572549 green:0.572549 blue:0.572549 alpha:1.0]} forState:UIControlStateNormal];
    }];
}

@end
