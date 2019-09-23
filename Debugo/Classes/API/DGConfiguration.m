//
//  DGConfiguration.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGConfiguration.h"
#import "DGAssistant.h"

@implementation DGConfiguration

- (void)setupBubbleLongPressAction:(void (^)(void))block {
    if (block) {
        DGAssistant.shared.bubbleLongPressBlock = block;
    }
}

- (void)setupActionPlugin:(void (^)(DGActionPluginConfiguration * _Nonnull))block {
    DGActionPluginConfiguration *configuration = [DGActionPluginConfiguration new];
    if (block) {
        block(configuration);
    }
    DGActionPlugin.shared.configuration = configuration;
}

- (void)setupFilePlugin:(void (^)(DGFilePluginConfiguration * _Nonnull))block {
    DGFilePluginConfiguration *configuration = [DGFilePluginConfiguration new];
    if (block) {
        block(configuration);
    }
    DGFilePlugin.shared.configuration = configuration;
}

- (void)setupAccountPlugin:(void (^)(DGAccountPluginConfiguration * _Nonnull))block {
    DGAccountPluginConfiguration *configuration = [DGAccountPluginConfiguration new];
    if (block) {
        block(configuration);
    }
    DGAccountPlugin.shared.configuration = configuration;
}

- (void)addCustomPlugin:(Class)plugin {
    if (![plugin conformsToProtocol:@protocol(DGPluginProtocol)]) {
        NSAssert(0, @"Debugo: 必须实现了 DGPluginProtocol 协议的工具才能添加");
        return;
    }
    [DGAssistant.shared.customPlugins addObject:plugin];
}

- (void)putPluginsToTabBar:(NSArray<Class> *)plugins {
    [DGAssistant.shared.tabBarPlugins removeAllObjects];
    [plugins enumerateObjectsUsingBlock:^(Class  _Nonnull plugin, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![plugin conformsToProtocol:@protocol(DGPluginProtocol)]) {
            NSAssert(0, @"Debugo: 必须实现了 DGPluginProtocol 协议的工具才能添加");
            return;
        }
        Class vcClass = dg_invoke(plugin, @selector(pluginViewControllerClass), nil);
        if (vcClass) {
            NSAssert(![vcClass isKindOfClass:[UINavigationController class]], @"Debugo: pluginViewControllerClass 不能是 UINavigationController 及其子类");
            [DGAssistant.shared.tabBarPlugins addObject:plugin];
        }else {
            NSAssert(!0, @"Debugo: 必须实现了 pluginViewControllerClass 方法，并且返回了控制器类才可以添加到 tabBar");
        }
    }];
}

@end
