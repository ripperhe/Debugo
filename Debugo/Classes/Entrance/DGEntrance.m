//
//  DGEntrance.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGEntrance.h"
#import "DGCommon.h"
#import "DGBubble.h"

@interface DGEntrance ()

@property (nonatomic, weak) DGBubble *bubble;
@property (nonatomic, strong) DGDebugWindow *debugWindow;

@property (weak, nonatomic) CADisplayLink *link;
@property (assign, nonatomic) NSTimeInterval lastTime;
@property (assign, nonatomic) NSUInteger count;

@end

@implementation DGEntrance

static DGEntrance *_instance;
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

#pragma mark - bubble
- (void)showBubble {
    if (self.bubble) {
        [self.bubble setHidden:NO];
        return;
    }
    
    DGBubble *bubble = [[DGBubble alloc] initWithFrame:CGRectMake(0, 200, 60, 60) config:nil];
    bubble.name = @"Bubble";
    //[bubble.button setImage:[DGBundle imageNamed:@"icon_bubble"] forState:UIControlStateNormal];
    [bubble.button setTintColor:[UIColor whiteColor]];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    if (@available(iOS 15.0, *)) {
        CGFloat preferred = UIScreen.mainScreen.maximumFramesPerSecond;
        link.preferredFrameRateRange = CAFrameRateRangeMake(60, 120, preferred);
    } else {
        
    }
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
    
    dg_weakify(self)
    [bubble setClickBlock:^(DGBubble *bubble) {
        dg_strongify(self)
        if (self.debugWindow) {
            if (self.debugWindow.isHidden == NO) {
                [self closeDebugWindow];
            }else {
                [self openDebugWindowWithIsFirstOpen:NO];
            }
        }else{
            self.debugWindow = [[DGDebugWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [self openDebugWindowWithIsFirstOpen:YES];
        }
    }];
    [bubble setLongPressStartBlock:^(DGBubble *bubble) {
        dg_strongify(self)
        if (self.bubbleLongPressBlock) {
            self.bubbleLongPressBlock();
        }
    }];
    [bubble show];
    self.bubble = bubble;
}

/// 隐藏悬浮球
- (void)hiddenBubble {
    [self.bubble removeFromScreen];
    [self.link invalidate];
}

- (void)tick:(CADisplayLink *)link {
    if (self.lastTime == 0) {
        self.lastTime = link.timestamp;
        return;
    }

    self.count++;
    NSTimeInterval delta = link.timestamp - self.lastTime;
    if (delta < 1)
        return;

    self.lastTime = link.timestamp;
    float fps = self.count / delta;
    self.count = 0;

    [self.bubble.button setTitle:[NSString stringWithFormat:@"%dFPS", (int)round(fps)] forState:UIControlStateNormal];
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
    // Window 隐藏再显示，不会调用 viewWillDisappear:, viewDidDisappear:
    // 此操作为了调用顶部控制器的 viewWillDisappear:, viewDidDisappear:
    UIViewController *topViewController = dg_topViewControllerForWindow(self.debugWindow);
    [topViewController beginAppearanceTransition:NO animated:NO];
    [containerWindow setHidden:YES];
    [topViewController endAppearanceTransition];
}

- (void)openDebugWindowWithIsFirstOpen:(BOOL)isFirstOpen {
    DGWindow *containerWindow = self.debugWindow;
    containerWindow.lastKeyWindow = [UIApplication sharedApplication].keyWindow;
    containerWindow.dg_canBecomeKeyWindow = YES;
    // Window 隐藏再显示，不会调用 viewWillAppear:, viewDidAppear:
    // 此操作为了调用顶部控制器的 viewWillAppear:, viewDidAppear:
    UIViewController *topViewController = dg_topViewControllerForWindow(self.debugWindow);
    if (!isFirstOpen) [topViewController beginAppearanceTransition:YES animated:NO];
    if (dg_keyboardWindow()) {
        // 有键盘的时候，防止挡住视图；没有键盘的时候，尽量不改变 keyWindow
        [containerWindow makeKeyAndVisible];
    }else {
        [containerWindow setHidden:NO];
    }
    if (!isFirstOpen) [topViewController endAppearanceTransition];
}

@end
