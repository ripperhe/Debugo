//
//  DGPluginManager.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/30.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPluginManager.h"

@implementation DGPluginManager

static DGPluginManager *_instance;
+ (instancetype)shared {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

#pragma mark -

- (void)addCustomPlugin:(Class<DGPluginProtocol>)plugin {
    if (![plugin conformsToProtocol:@protocol(DGPluginProtocol)]) {
        NSAssert(0, @"Debugo: 必须实现了 DGPluginProtocol 协议的工具才能添加");
        return;
    }
    [self.customPlugins addObject:plugin];
}

- (void)putPluginsToTabBar:(nullable NSArray<Class<DGPluginProtocol>> *)plugins {
    [self.tabBarPlugins removeAllObjects];
    [plugins enumerateObjectsUsingBlock:^(Class  _Nonnull plugin, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![plugin conformsToProtocol:@protocol(DGPluginProtocol)]) {
            NSAssert(0, @"Debugo: 必须实现了 DGPluginProtocol 协议的工具才能添加");
            return;
        }
        Class vcClass = dg_invoke(plugin, @selector(pluginViewControllerClass), nil);
        if (vcClass) {
            NSAssert(![vcClass isKindOfClass:[UINavigationController class]], @"Debugo: pluginViewControllerClass 不能是 UINavigationController 及其子类");
            [self.tabBarPlugins addObject:plugin];
        }else {
            NSAssert(!0, @"Debugo: 必须实现了 pluginViewControllerClass 方法，并且返回了控制器类才可以添加到 tabBar");
        }
    }];
}

#pragma mark - getter

- (NSArray<Class> *)debugoPlugins {
    if (!_debugoPlugins) {
        _debugoPlugins = @[
            DGActionPlugin.class,
            DGFilePlugin.class,
            DGAppInfoPlugin.class,
            DGAccountPlugin.class,
            DGApplePlugin.class,
            DGTouchPlugin.class,
            DGColorPlugin.class,
            DGPodPlugin.class,
        ];
    }
    return _debugoPlugins;
}

- (NSMutableArray *)customPlugins {
    if (!_customPlugins) {
        _customPlugins = [NSMutableArray array];
    }
    return _customPlugins;
}

- (NSMutableArray *)tabBarPlugins {
    if (!_tabBarPlugins) {
        _tabBarPlugins = [NSMutableArray array];
        // 默认显示指令组件
        [_tabBarPlugins addObject:DGActionPlugin.class];
    }
    return _tabBarPlugins;
}

@end
