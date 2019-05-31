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
#import "DGSuspensionBubble.h"
#import "DGTouchMonitor.h"
#import "DGDebuggingOverlay.h"
#import "DGBase.h"
#import "DGConfiguration.h"
#import "DGDebugViewController.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const DGDebugWindowWillShowNotificationKey;
extern NSString *const DGDebugWindowDidHiddenNotificationKey;


@interface DGAssistant : NSObject

@property (nonatomic, strong, readonly) DGConfiguration *configuration;

@property (nonatomic, strong, nullable) NSMutableDictionary <NSString *, DGOrderedDictionary <NSString *, DGAction *>*>*usersActionsDic;
@property (nonatomic, strong, nullable) DGOrderedDictionary <NSString *, DGAction *>*anonymousActionDic;
@property (nonatomic, strong, nullable) NSArray <DGAccount *>*currentCommonAccountArray;
@property (nonatomic, strong, nullable) DGOrderedDictionary <NSString *, DGAccount *>*temporaryAccountDic;

+ (instancetype)shared;

- (void)setupWithConfiguration:(DGConfiguration *)configuration;
- (void)reset;

- (void)addActionForUser:(nullable NSString *)user withTitle:(NSString *)title autoClose:(BOOL)autoClose handler:(DGActionHandlerBlock)handler;
- (void)addAccountWithUsername:(NSString *)username password:(NSString *)password;

///------------------------------------------------
/// Debug Bubble
///------------------------------------------------

@property (nonatomic, weak, readonly) DGSuspensionBubble *debugBubble;
@property (nonatomic, weak, readonly) DGWindow *debugWindow;
@property (nonatomic, weak, readonly) DGDebugViewController *debugViewController;

- (void)showDebugBubble;
- (void)removeDebugBubble;
- (void)closeDebugWindow;
- (void)removeDebugWindow;
- (void)refreshDebugBubbleWithIsOpenFPS:(BOOL)isOpenFPS;

///------------------------------------------------
/// Login Bubble
///------------------------------------------------

@property (nonatomic, weak, readonly) DGSuspensionBubble *loginBubble;
@property (nonatomic, weak, readonly) DGWindow *loginWindow;

- (void)showLoginBubble;
- (void)removeLoginBubble;
- (void)removeLoginWindow;

@end

NS_ASSUME_NONNULL_END
