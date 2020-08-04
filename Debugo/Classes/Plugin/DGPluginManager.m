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
            NSAssert(0, @"Debugo: 必须实现了 DGPluginProtocol 协议的工具才能添加到 tab bar");
            return;
        }
        if (![plugin respondsToSelector:@selector(pluginViewController)]) {
            NSAssert(0, @"Debugo: Debugo: 必须实现了 pluginViewController 方法的工具才能添加到 tab bar");
            return;
        }
        [self.tabBarPlugins addObject:plugin];
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
