
//
//  DGPluginViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/8.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPluginViewController.h"
#import "DGAssistant.h"
#import "DGAppInfoPlugin.h"
#import "DGAccountPlugin.h"
#import "DGApplePlugin.h"
#import "DGTouchPlugin.h"

@interface DGPluginViewController ()

@end

@implementation DGPluginViewController

- (void)setupDatasouce {
    [self addPlugin:DGAppInfoPlugin.class];
    [self addPlugin:DGAccountPlugin.class];
    [self addPlugin:DGApplePlugin.class];
    [self addPlugin:DGTouchPlugin.class];
    
    // 自定义 plugin
    [DGAssistant.shared.customPlugins enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addPlugin:obj];
    }];
}

- (void)addPlugin:(id)plugin {
    if (![plugin conformsToProtocol:@protocol(DGPluginProtocol)]) {
        NSAssert(0, @"Debugo: 只能添加组件");
        return;
    }
    
    [self addGrid:^(DGCommonGridConfiguration * _Nonnull configuration) {
        configuration.title = dg_invoke(plugin, @selector(pluginName), nil) ?: NSStringFromClass([plugin class]);
        configuration.image = dg_invoke(plugin, @selector(pluginImage), nil) ?: [DGBundle imageNamed:@"plugin_default"];
        Class vcClass = dg_invoke(plugin, @selector(pluginViewControllerClass), nil);
        if (vcClass) {
            // 有控制器，跳转到控制器
            configuration.selectedPushViewControllerClass = vcClass;
        }else {
            // 无控制器，直接启用
            [configuration setSelectedBlock:^{
                [DGAssistant.shared closeDebugWindow];
                dg_invoke(plugin, @selector(setPluginSwitch:), @[@YES]);
            }];
        }
    }];
}

@end
