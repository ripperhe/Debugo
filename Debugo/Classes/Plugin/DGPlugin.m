//
//  DGPlugin.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/9.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPlugin.h"
#import "DGCommon.h"

@implementation DGPlugin

+ (NSString *)pluginName {
    return NSStringFromClass([self class]);
}

+ (UIImage *)pluginImage {
    return [DGBundle imageNamed:@"plugin_default"];
}

+ (UIImage *)pluginTabBarImage:(BOOL)isSelected {
    if (isSelected) {
        return [DGBundle imageNamed:@"tab_default_selected"];
    }
    return [DGBundle imageNamed:@"tab_default_normal"];
}

+ (BOOL)pluginSupport {
    return YES;
}

+ (UIViewController *)pluginViewController {
    return nil;
}

+ (void)setPluginSwitch:(BOOL)pluginSwitch {
}

+ (BOOL)pluginSwitch {
    return NO;
}

@end
