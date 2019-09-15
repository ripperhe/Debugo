//
//  CustomPlugin.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/15.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "CustomPlugin.h"

@implementation CustomPlugin

+ (NSString *)pluginName {
    return @"自定义工具";
}

+ (void)setPluginSwitch:(BOOL)pluginSwitch {
    if (pluginSwitch) {
        // 启动
        NSLog(@"启动自定义工具");
    }
}

@end
