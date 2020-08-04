//
//  DGColorPlugin.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/26.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGColorPlugin.h"
#import "DGCommon.h"
#import "DGColorPluginViewController.h"

@implementation DGColorPlugin

+ (NSString *)pluginName {
    return @"UIView背景色";
}

+ (UIImage *)pluginImage {
    return [DGBundle imageNamed:@"plugin_uiviewcolor"];
}

+ (UIImage *)pluginTabBarImage:(BOOL)isSelected {
    if (isSelected) {
        return [DGBundle imageNamed:@"tab_uiviewcolor_selected"];
    }
    return [DGBundle imageNamed:@"tab_uiviewcolor_normal"];
}

+ (UIViewController *)pluginViewController {
    return [DGColorPluginViewController new];
}

+ (BOOL)pluginSwitch {
    UIViewController *vc = dg_topViewController();
    if ([vc isViewLoaded] && vc.view.dg_renderType > 0) {
        return YES;
    }
    return NO;
}

+ (void)setPluginSwitch:(BOOL)pluginSwitch {
    UIViewController *vc = dg_topViewController();
    if (pluginSwitch) {
        vc.view.dg_renderType = DGRenderTypeLeaves;
    }else {
        vc.view.dg_renderType = DGRenderTypeNone;
    }
}

@end
