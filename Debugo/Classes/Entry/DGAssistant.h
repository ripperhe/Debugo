//
//  DGAssistant.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DGDebugo+Additional.h"
#import "DGBubble.h"
#import "DGTouchMonitor.h"
#import "DGDebuggingOverlay.h"
#import "DGCommon.h"
#import "DGConfiguration.h"
#import "DGDebugViewController.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const DGDebugWindowWillShowNotificationKey;
extern NSString *const DGDebugWindowDidHiddenNotificationKey;


@interface DGAssistant : NSObject

@property (nonatomic, strong, readonly) DGConfiguration *configuration;

+ (instancetype)shared;

- (void)setupWithConfiguration:(DGConfiguration *)configuration;
- (void)reset;

///------------------------------------------------
/// Debug Bubble
///------------------------------------------------

@property (nonatomic, weak, readonly) DGBubble *debugBubble;
@property (nonatomic, strong, readonly) DGWindow *debugWindow;
@property (nonatomic, weak, readonly) DGDebugViewController *debugViewController;

- (void)showDebugBubble;
- (void)removeDebugBubble;
- (void)closeDebugWindow;
- (void)removeDebugWindow;
- (void)refreshDebugBubbleWithIsOpenFPS:(BOOL)isOpenFPS;

@end

NS_ASSUME_NONNULL_END
