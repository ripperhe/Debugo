
//
//  DGPluginViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/8.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPluginViewController.h"
#import "DGAssistant.h"
#import "DGAppInfoViewController.h"
#import "DGAccountPlugin.h"
#import "DGDebuggingOverlay.h"
#import "DGAppInfoPlugin.h"

@interface DGPluginViewController ()

@end

@implementation DGPluginViewController

- (void)setupDatasouce {
    [self addPlugin:DGAppInfoPlugin.class];
//    [self addGrid:^(DGCommonGridConfiguration * _Nonnull configuration) {
//        configuration.title = @"APP信息";
//        configuration.imageName = @"app";
//        configuration.selectedPushViewControllerClass = DGAppInfoViewController.class;
//    }];
    
    [self addGrid:^(DGCommonGridConfiguration * _Nonnull configuration) {
        configuration.title = @"快速登录";
        configuration.imageName = @"app";
        [configuration setSelectedBlock:^{
            [DGAssistant.shared closeDebugWindow];
            [DGAccountPlugin.shared showLoginWindow];
        }];
    }];
    
    [self addGrid:^(DGCommonGridConfiguration * _Nonnull configuration) {
        configuration.title = @"Apple内部神器";
        configuration.imageName = @"app";
        [configuration setSelectedBlock:^{
            [DGAssistant.shared closeDebugWindow];
            [DGDebuggingOverlay showDebuggingInformation];
        }];
    }];
}

- (void)addPlugin:(Class<DGPluginProtocol>)pluginClass {
    if (![pluginClass.class isSubclassOfClass:[DGPlugin class]]) {
        return;
    }
    if (![pluginClass performSelector:@selector(pluginCanFire)]) {
        return;
    }
    
    [self addGrid:^(DGCommonGridConfiguration * _Nonnull configuration) {
        configuration.title = [pluginClass performSelector:@selector(pluginName)];
        configuration.image = [pluginClass performSelector:@selector(pluginImage)];
        Class vcClass = [pluginClass performSelector:@selector(pluginViewControllerClass)];
        if (vcClass) {
            configuration.selectedPushViewControllerClass = vcClass;
        }else {
            [configuration setSelectedBlock:^{
                [DGAssistant.shared closeDebugWindow];
                [pluginClass performSelector:@selector(pluginFire)];
            }];
        }
    }];
}

@end
