
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

@implementation DGPluginGridViewController

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
        Class vcClass = dg_invoke(plugin, @selector(pluginViewControllerClass), nil);
        if (vcClass) {
            // 有控制器，跳转到控制器
            NSAssert(![vcClass isKindOfClass:[UINavigationController class]], @"Debugo: pluginViewControllerClass 不能是 UINavigationController 及其子类");
            configuration.selectedPushViewControllerClass = vcClass;
        }else {
            // 无控制器，直接启用
            [configuration setSelectedBlock:^{
                [DGEntrance.shared closeDebugWindow];
                dg_invoke(plugin, @selector(setPluginSwitch:), @[@YES]);
            }];
        }
    }];
}

@end
