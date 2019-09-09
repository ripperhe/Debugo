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
#import "DGQuickLoginViewController.h"
#import "DGAccountManager.h"
#import "DGActionManager.h"
#import "DGFileManager.h"

NSString *const DGDebugWindowWillShowNotificationKey = @"DGDebugWindowWillShowNotificationKey";
NSString *const DGDebugWindowDidHiddenNotificationKey = @"DGDebugWindowDidHiddenNotificationKey";

NSInteger const DGDebugBubbleTag = 1;
UIWindowLevel const DGContentWindowLevel = 999999;

@interface DGAssistant ()<DGSuspensionBubbleDelegate>

@property (nonatomic, weak) DGSuspensionBubble *debugBubble;
@property (nonatomic, strong) DGWindow *debugWindow;
@property (nonatomic, weak, nullable) DGDebugViewController *debugViewController;

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
    _instance->_configuration = [configuration copy];
    
    // setting
    [DGCache.shared.settingPlister setBool:self.configuration.isShowBottomBarWhenPushed forKey:kDGSettingIsShowBottomBarWhenPushed];
    
    [self refreshDebugBubbleWithIsOpenFPS:self.configuration.isOpenFPS];
    [DGCache.shared.settingPlister setBool:self.configuration.isOpenFPS forKey:kDGSettingIsOpenFPS];
    
    DGTouchMonitor.shared.shouldDisplayTouches = self.configuration.isShowTouches;
    [DGCache.shared.settingPlister setBool:self.configuration.isShowTouches forKey:kDGSettingIsShowTouches];

    // file
    DGFileManager.shared.configuration = configuration.fileConfiguration;
    
    // account
    [DGAccountManager.shared setupWithConfiguration:configuration.accountConfiguration];

    // action
    DGActionManager.shared.commonActions = configuration.commonActions;
    
    [self showDebugBubble];
}

- (void)reset {
    [self refreshDebugBubbleWithIsOpenFPS:NO];
    DGTouchMonitor.shared.shouldDisplayTouches = NO;
    
    self->_configuration = nil;
    
    [self removeDebugBubble];
    [self removeDebugWindow];
    
    [DGAccountManager.shared reset];
}


#pragma mark - debug bubble
- (void)refreshDebugBubbleWithIsOpenFPS:(BOOL)isOpenFPS {
    if (!self.debugBubble) return;
    
    if (isOpenFPS) {
        if (!self.debugBubble.dg_weakExtObj) {
            // 添加 FPSLabel
            DGFPSLabel *label = [DGFPSLabel new];
            label.backgroundColor = [UIColor clearColor];
            label.frame = CGRectMake(0, 0, 50, 30);
            label.center = CGPointMake(55/2.0, 55/2.0);
            [self.debugBubble.contentView addSubview:label];
            self.debugBubble.dg_weakExtObj = label;
        }
        self.debugBubble.button.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:1.00];
        [self.debugBubble.button setImage:nil forState:UIControlStateNormal];
    }else{
        [self.debugBubble.dg_weakExtObj removeFromSuperview];
        self.debugBubble.dg_weakExtObj = nil;
        self.debugBubble.button.backgroundColor = [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0];
        [self.debugBubble.button setImage:[DGBundle imageNamed:@"debug_bubble"] forState:UIControlStateNormal];
    }
}

- (void)showDebugBubble {
    if (self.debugBubble) {
        [self.debugBubble setHidden:NO];
        return;
    }
    
    DGSuspensionBubbleConfig *config = [DGSuspensionBubbleConfig new];
    config.buttonType = UIButtonTypeSystem;
    config.leanStateAlpha = .9;
    
    DGSuspensionBubble *debugBubble = [[DGSuspensionBubble alloc] initWithFrame:CGRectMake(400, kDGScreenH - (255 + 55 + kDGBottomSafeMargin), 55, 55)
                                                                       config:config];
    debugBubble.name = @"Debug Bubble";
    debugBubble.tag = DGDebugBubbleTag;
    debugBubble.dg_delegate = self;
    [debugBubble.button setTintColor:[UIColor whiteColor]];
    [debugBubble show];
    self.debugBubble = debugBubble;
    [self refreshDebugBubbleWithIsOpenFPS:self.configuration.isOpenFPS];
}

- (void)removeDebugBubble {
    [self.debugBubble removeFromScreen];
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


#pragma mark - DGSuspensionBubbleDelegate
- (void)suspensionBubbleClick:(DGSuspensionBubble *)suspensionBubble {
    // debug
    if (self.debugWindow) {
        if (self.debugWindow.isHidden == NO) {
            // hidden
            [self closeDebugWindow];
        }else {
            // show
//            [self removeLoginWindow];
            [self openDebugWindow];
        }
    }else{
        // create
        DGDebugViewController *debugVC = [[DGDebugViewController alloc] init];
        DGWindow *window = [[DGWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.name = @"Debug Window";
        window.rootViewController = debugVC;
        window.windowLevel = DGContentWindowLevel;
        self.debugViewController = debugVC;
        self.debugWindow = window;
        
        // show
//        [self removeLoginWindow];
        [self openDebugWindow];
    }
}

@end
