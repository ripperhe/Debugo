//
//  DGTouchMonitor.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGTouchMonitor.h"
#import "DGTouchWindow.h"
#import "DGTouchViewController.h"
#import "UIApplication+DGTouchMonitor.h"

@interface DGTouchMonitor ()

@property (nonatomic, strong) DGTouchWindow *touchWindow;

@end

@implementation DGTouchMonitor

//+ (void)initialize {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//#if DGTouchMonitorCanBeEnabled
//        printf("◦ DGTouchMonitorCanBeEnabled ✅\n");
//#else
//        printf("◦ DGTouchMonitorCanBeEnabled ❌\n");
//#endif
//    });
//}

static DGTouchMonitor *_instance;
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
        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(handleInterfaceEvent:) name:DGTouchMonitorDidSendTouchEventNotification object:nil];
    });
    return _instance;
}

#pragma mark - setter
- (void)setShouldDisplayTouches:(BOOL)shouldDisplayTouches {
    _shouldDisplayTouches = shouldDisplayTouches;
    
    if (shouldDisplayTouches) {
        self.touchWindow.hidden = NO;
    }else {
        self.touchWindow.rootViewController = nil;
        self.touchWindow.hidden = YES;
        self.touchWindow = nil;
    }
}

#pragma mark - getter
- (DGTouchWindow *)touchWindow {
    if (!_touchWindow) {
        _touchWindow = [[DGTouchWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _touchWindow.rootViewController = [DGTouchViewController new];
    }
    return _touchWindow;
}

#pragma mark - notification
- (void)handleInterfaceEvent:(NSNotification *)notification {
    if (self.shouldDisplayTouches && [notification.object isKindOfClass:[UIEvent class]]) {
        UIEvent* event = notification.object;
        
        if (event.type == UIEventTypeTouches) {
            [self.touchWindow displayEvent:event];
        }
    }
}

@end
