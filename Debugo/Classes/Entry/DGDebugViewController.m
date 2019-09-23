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
#import "DGPluginViewController.h"

@interface DGDebugViewController ()

@end

@implementation DGDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray array];
    
    [DGAssistant.shared.tabBarPlugins enumerateObjectsUsingBlock:^(Class<DGPluginProtocol>  _Nonnull plugin, NSUInteger idx, BOOL * _Nonnull stop) {
        Class viewControllerClass = dg_invoke(plugin, @selector(pluginViewControllerClass), nil);
        if (viewControllerClass) {
            NSString *name = dg_invoke(plugin, @selector(pluginName), nil) ?: NSStringFromClass([plugin class]);
            UIImage *image = dg_invoke(plugin, @selector(pluginTabBarImage:), @[@(NO)]) ?: [DGPlugin pluginTabBarImage:NO];
            UIImage *selectedImage = dg_invoke(plugin, @selector(pluginTabBarImage:), @[@(YES)]) ?: [DGPlugin pluginTabBarImage:YES];

            UIViewController *vc = [viewControllerClass new];
            vc.navigationItem.title = name;
            DGNavigationController *navigationController = [[DGNavigationController alloc] initWithRootViewController:vc];
            navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:name image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            [viewControllers addObject:navigationController];
        }
    }];
    
    DGPluginViewController *pluginVC = [DGPluginViewController new];
    pluginVC.navigationItem.title = @"工具";
    DGNavigationController *pluginNavigationController = [[DGNavigationController alloc] initWithRootViewController:pluginVC];
    pluginNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"工具" image:[[DGBundle imageNamed:@"tab_plugin_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[DGBundle imageNamed:@"tab_plugin_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [viewControllers addObject:pluginNavigationController];
    
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kDGHighlightColor} forState:UIControlStateSelected];
        [obj.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.572549 green:0.572549 blue:0.572549 alpha:1.0]} forState:UIControlStateNormal];
    }];
    
    [self setViewControllers:viewControllers];
}

@end
