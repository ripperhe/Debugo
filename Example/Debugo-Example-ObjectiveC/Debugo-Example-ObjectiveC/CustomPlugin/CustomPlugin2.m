//
//  CustomPlugin2.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/15.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "CustomPlugin2.h"
#import "CustomPlugin2ViewController.h"

@implementation CustomPlugin2

+ (Class)pluginViewControllerClass {
    // 如果点击工具之后，需要跳转到页面，而不是直接开启工具的话，就在这里返回需要跳转的控制器类
    return CustomPlugin2ViewController.class;
}

static BOOL _switch = NO;
+ (NSString *)pluginName {
    return @"自定义工具2";
}

+ (void)setPluginSwitch:(BOOL)pluginSwitch {
    if (pluginSwitch == _switch) {
        return;
    }
    _switch = pluginSwitch;
    if (pluginSwitch) {
        NSLog(@"启动自定义工具2");
    }else {
        NSLog(@"关闭自定义工具2");
    }
}

+ (BOOL)pluginSwitch {
    return _switch;
}

@end
