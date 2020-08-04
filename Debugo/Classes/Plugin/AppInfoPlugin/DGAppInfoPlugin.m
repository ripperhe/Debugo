//
//  DGAppInfoPlugin.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/9.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGAppInfoPlugin.h"
#import "DGAppInfoViewController.h"
#import "DGCommon.h"

@implementation DGAppInfoPlugin

+ (NSString *)pluginName {
    return @"APP信息";
}

+ (UIImage *)pluginImage {
    return [DGBundle imageNamed:@"plugin_appinfo"];
}

+ (UIImage *)pluginTabBarImage:(BOOL)isSelected {
    if (isSelected) {
        return [DGBundle imageNamed:@"tab_appinfo_selected"];
    }
    return [DGBundle imageNamed:@"tab_appinfo_normal"];
}

+ (UIViewController *)pluginViewController {
    return [DGAppInfoViewController new];
}

@end
