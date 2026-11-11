
//
//  DGPluginGridViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/8.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPluginGridViewController.h"
#import "DGCommon.h"
#import "DGPluginManager.h"
#import "DGEntrance.h"
#import "Debugo.h"

@implementation DGPluginGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dg_weakify(self)
    [DGPodPlugin queryLatestPodInfoFromCocoaPodsSpecRepoWithPodName:@"Debugo" completion:^(NSDictionary * _Nullable podInfo, NSError * _Nullable error) {
        dg_strongify(self)
        if (!podInfo) return;
        NSString *version = [podInfo objectForKey:@"version"];
        if ([version isKindOfClass:NSString.class] && version.length) {
            if ([DGPodPlugin compareVersionA:Debugo.version withVersionB:version] == NSOrderedAscending) {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本(%@)", version] style:UIBarButtonItemStylePlain target:self action:@selector(pushVersionViewController)];
            }
        }
    }];
}

- (void)pushVersionViewController {
    NSURL *url = [NSURL URLWithString:@"https://github.com/ripperhe/Debugo/releases"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        DGLog(@"\n%d", success);
    }];
}

#pragma mark -

- (void)setupDatasouce {
    [DGPluginManager.shared.debugoPlugins enumerateObjectsUsingBlock:^(Class<DGPluginProtocol>  _Nonnull plugin, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addPlugin:plugin];
    }];
    
    [DGPluginManager.shared.customPlugins enumerateObjectsUsingBlock:^(Class<DGPluginProtocol>  _Nonnull plugin, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addPlugin:plugin];
    }];
}

- (void)addPlugin:(Class)plugin {
    if ([DGPluginManager.shared.tabBarPlugins containsObject:plugin]) {
        return;
    }

    if (![plugin conformsToProtocol:@protocol(DGPluginProtocol)]) {
        NSAssert(0, @"Debugo: 只能添加组件");
        return;
    }
    NSNumber *support = dg_invoke(plugin, @selector(pluginSupport), nil);
    if (support && ([support boolValue] == NO)) {
        return;
    }
    
    dg_weakify(self)
    [self addGrid:^(DGCommonGridConfiguration * _Nonnull configuration) {
        dg_strongify(self)
        configuration.title = dg_invoke(plugin, @selector(pluginName), nil) ?: NSStringFromClass([plugin class]);
        configuration.image = dg_invoke(plugin, @selector(pluginImage), nil) ?: [DGPlugin pluginImage];
        configuration.selectedPushViewControlerBlock = ^UIViewController * _Nonnull{
            UIViewController *vc = dg_invoke(plugin, @selector(pluginViewController), nil);
            if (vc) {
                // 有控制器，跳转到控制器
                NSAssert(![vc isKindOfClass:[UINavigationController class]], @"Debugo: pluginViewController 不能是 UINavigationController 及其子类");
                return vc;
            } else {
                // 无控制器，直接启用
                [DGEntrance.shared closeDebugWindow];
                dg_invoke(plugin, @selector(setPluginSwitch:), @[@YES]);
                return nil;
            }
        };
    }];
}

@end
