//
//  DGAssistant.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGAssistant.h"
#import "DGFPSLabel.h"
#import "DGCache.h"
#import "DGAccountPlugin.h"
#import "DGActionPlugin.h"
#import "DGFilePlugin.h"
#import "DGTouchPlugin.h"
#import "DGApplePlugin.h"


NSString *const DGDebugWindowWillShowNotificationKey = @"DGDebugWindowWillShowNotificationKey";
NSString *const DGDebugWindowDidHiddenNotificationKey = @"DGDebugWindowDidHiddenNotificationKey";

UIWindowLevel const DGContentWindowLevel = 1999999;

@interface DGAssistant ()

@property (nonatomic, weak) DGBubble *bubble;
@property (nonatomic, strong) DGDebugWindow *debugWindow;

@end

@implementation DGAssistant

static DGAssistant *_instance;
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
    });
    return _instance;
}

#pragma mark -
- (void)setupWithConfiguration:(DGConfiguration *)configuration {
    _instance->_configuration = configuration;
    
    [self showBubble];
}

#pragma mark - bubble
- (void)showBubble {
    if (self.bubble) {
        [self.bubble setHidden:NO];
        return;
    }
    
    DGBubble *bubble = [[DGBubble alloc] initWithFrame:CGRectMake(400, kDGScreenH - (255 + 55 + kDGBottomSafeMargin), 55, 55)
                                                                       config:nil];
    bubble.name = @"Bubble";
    [bubble.button setImage:[DGBundle imageNamed:@"bubble"] forState:UIControlStateNormal];
    [bubble.button setTintColor:[UIColor whiteColor]];
    dg_weakify(self)
    [bubble setClickBlock:^(DGBubble *bubble) {
        dg_strongify(self)
        DGLog(@"start");
        // debug
        if (self.debugWindow) {
            if (self.debugWindow.isHidden == NO) {
                // hidden
                [self closeDebugWindow];
            }else {
                // show
                [self openDebugWindow];
            }
        }else{
            // create
            self.debugWindow = [[DGDebugWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            // show
            [self openDebugWindow];
        }
        DGLog(@"end");
    }];
    [bubble show];
    self.bubble = bubble;
}

#pragma mark - debug view controller
- (void)removeDebugWindow {
    [self closeDebugWindow];
    [self.debugWindow destroy];
    self.debugWindow = nil;
}

- (void)closeDebugWindow {
    DGWindow *containerWindow = self.debugWindow;
    containerWindow.dg_canBecomeKeyWindow = NO;
    if (containerWindow.isKeyWindow) {
        [containerWindow.lastKeyWindow makeKeyWindow];
        containerWindow.lastKeyWindow = nil;
    }
    [containerWindow setHidden:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:DGDebugWindowDidHiddenNotificationKey object:nil userInfo:nil];
}

- (void)openDebugWindow {
    [[NSNotificationCenter defaultCenter] postNotificationName:DGDebugWindowWillShowNotificationKey object:nil];
    DGWindow *containerWindow = self.debugWindow;
    containerWindow.lastKeyWindow = [UIApplication sharedApplication].keyWindow;
    containerWindow.dg_canBecomeKeyWindow = YES;
    if ([DGUIMagic keyboardWindow]) {
        // 有键盘的时候，防止挡住视图；没有键盘的时候，尽量不改变 keyWindow
        [containerWindow makeKeyAndVisible];
    }else {
        [containerWindow setHidden:NO];
    }
}

@end
