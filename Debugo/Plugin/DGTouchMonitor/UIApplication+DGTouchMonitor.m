//
//  UIApplication+Event.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "UIApplication+DGTouchMonitor.h"
#import "DGBase.h"
#import "DebugoEnable.h"

NSString * const DGTouchMonitorDidSendTouchEventNotification = @"DGTouchMonitorDidSendTouchEventNotification";

@implementation UIApplication (DGTouchMonitor)

+ (void)load {
#if DebugoCanBeEnabled
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIApplication dg_swizzleInstanceMethod:@selector(sendEvent:) newSelector:@selector(dg_sendEvent:)];
    });
#endif
}

- (void)dg_sendEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DGTouchMonitorDidSendTouchEventNotification object:event];
    }
    
    [self dg_sendEvent:event];
}

@end
