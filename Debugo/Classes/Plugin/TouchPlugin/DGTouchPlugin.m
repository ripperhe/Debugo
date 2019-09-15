//
//  DGTouchPlugin.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGTouchPlugin.h"
#import "DebugoEnable.h"
#import "DGCommon.h"
#import "DGTouchWindow.h"
#import "DGTouchPluginViewController.h"

static BOOL _showTouch = NO;
static DGTouchWindow *_touchWindow = nil;

@implementation DGTouchPlugin

+ (NSString *)pluginName {
    return @"触摸监听";
}

+ (UIImage *)pluginImage {
    return [DGBundle imageNamed:@"plugin_touch"];
}

+ (Class)pluginViewControllerClass {
    return [DGTouchPluginViewController class];
}

+ (BOOL)pluginSwitch {
    return _showTouch;
}

+ (void)setPluginSwitch:(BOOL)pluginSwitch {
    _showTouch = pluginSwitch;
    if (pluginSwitch) {
        if (!_touchWindow) {
            _touchWindow = [[DGTouchWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
        _touchWindow.hidden = NO;
    }else {
        [_touchWindow destroy];
        _touchWindow = nil;
    }
}

+ (void)handleToucheEvent:(UIEvent *)event {
    if (_showTouch) {
        [_touchWindow displayEvent:event];
    }
}
@end

@interface UIApplication (DGTouchPlugin)

@end

@implementation UIApplication (DGTouchPlugin)

#if DebugoCanBeEnabled
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIApplication dg_swizzleInstanceMethod:@selector(sendEvent:) newSelector:@selector(dg_sendEvent:)];
    });
}

- (void)dg_sendEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {
        [DGTouchPlugin handleToucheEvent:event];
    }
    [self dg_sendEvent:event];
}
#endif

@end
