//
//  DGTouchPlugin.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGTouchPlugin.h"
#import "DGCommon.h"
#import "DGTouchWindow.h"
#import "UIApplication+DGTouchPlugin.h"
#import "DGTouchPluginViewController.h"

@interface DGTouchPlugin ()

@property (nonatomic, assign) BOOL shouldDisplayTouches;
@property (nonatomic, strong) DGTouchWindow *touchWindow;

@end

@implementation DGTouchPlugin

+ (NSString *)pluginName {
    return @"触摸监听";
}

+ (UIImage *)pluginImage {
    return [DGBundle imageNamed:@"app"];
}

+ (Class)pluginViewControllerClass {
    return [DGTouchPluginViewController class];
}

+ (BOOL)pluginSwitch {
    return [[self shared] shouldDisplayTouches];
}

+ (void)setPluginSwitch:(BOOL)pluginSwitch {
    [[self shared] setShouldDisplayTouches:pluginSwitch];
}

#pragma mark -

static DGTouchPlugin *_instance;
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
        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(handleInterfaceEvent:) name:DGTouchPluginDidSendTouchEventNotification object:nil];
    });
    return _instance;
}

#pragma mark - setter
- (void)setShouldDisplayTouches:(BOOL)shouldDisplayTouches {
    _shouldDisplayTouches = shouldDisplayTouches;
    
    if (shouldDisplayTouches) {
        self.touchWindow.hidden = NO;
    }else {
        // 防止在不需要展示的时候也懒加载 touchWindow
        _touchWindow.rootViewController = nil;
        _touchWindow.hidden = YES;
        _touchWindow = nil;
    }
}

#pragma mark - getter
- (DGTouchWindow *)touchWindow {
    if (!_touchWindow) {
        _touchWindow = [[DGTouchWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _touchWindow.rootViewController = [UIViewController new];
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
