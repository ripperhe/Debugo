//
//  DGDebugViewController.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGDebugViewController.h"
#import "DGCommon.h"
#import "DGAssistant.h"
#import "DGNavigationController.h"
#import "DGActionViewController.h"
#import "DGFileViewController.h"
#import "DGPluginViewController.h"

@interface DGDebugViewController ()

@end

@implementation DGDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DGActionViewController *actionVC = [[DGActionViewController alloc] initWithStyle:UITableViewStyleGrouped];
    actionVC.navigationItem.title = @"指令";
    DGNavigationController *actionNavigationVC = [[DGNavigationController alloc] initWithRootViewController:actionVC];
    actionNavigationVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"指令" image:[[DGBundle imageNamed:@"tab_action_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[DGBundle imageNamed:@"tab_action_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    DGFileViewController *fileVC = [[DGFileViewController alloc] initWithStyle:UITableViewStyleGrouped];
    fileVC.navigationItem.title = @"文件";
    DGNavigationController *fileNavigationVC = [[DGNavigationController alloc] initWithRootViewController:fileVC];
    fileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"文件" image:[[DGBundle imageNamed:@"tab_file_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[DGBundle imageNamed:@"tab_file_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    DGPluginViewController *pluginVC = [DGPluginViewController new];
    pluginVC.navigationItem.title = @"工具";
    DGNavigationController *pluginNavigationVC = [[DGNavigationController alloc] initWithRootViewController:pluginVC];
    pluginVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"工具" image:[[DGBundle imageNamed:@"tab_plugin_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[DGBundle imageNamed:@"tab_plugin_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    NSArray<UIViewController *> *viewControllers = @[actionNavigationVC, fileNavigationVC, pluginNavigationVC];
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kDGHighlightColor} forState:UIControlStateSelected];
        [obj.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.572549 green:0.572549 blue:0.572549 alpha:1.0]} forState:UIControlStateNormal];
    }];
    self.viewControllers = viewControllers;
}

@end
