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
#import "DGSuspensionView.h"
#import "DGTouchMonitor.h"
#import "DGDebuggingOverlay.h"
#import "DGBase.h"
#import "DGConfiguration.h"
#import "DGViewController.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const DGDebugWindowWillShowNotificationKey;
extern NSString *const DGDebugWindowDidHiddenNotificationKey;


@interface DGAssistant : NSObject

@property (nonatomic, strong, readonly) DGConfiguration *configuration;

@property (nonatomic, strong, nullable) NSMutableDictionary <NSString *, DGOrderedDictionary <NSString *, DGTestAction *>*>*usersTestActionsDic;
@property (nonatomic, strong, nullable) DGOrderedDictionary <NSString *, DGTestAction *>*anonymousTestActionDic;
@property (nonatomic, strong, nullable) NSArray <DGAccount *>*currentCommonAccountArray;
@property (nonatomic, strong, nullable) DGOrderedDictionary <NSString *, DGAccount *>*temporaryAccountDic;

+ (instancetype)shared;

- (void)setupWithConfiguration:(DGConfiguration *)configuration;
- (void)reset;

- (void)addTestActionForUser:(nullable NSString *)user withTitle:(NSString *)title autoClose:(BOOL)autoClose handler:(DGTestActionHandlerBlock)handler;
- (void)addAccountWithUsername:(NSString *)username password:(NSString *)password;

///------------------------------------------------
/// Debug Bubble
///------------------------------------------------

@property (nonatomic, weak, readonly) DGSuspensionView *debugBubble;
@property (nonatomic, weak, readonly) DGSuspensionContainer *debugViewControllerContainerWindow;
@property (nonatomic, weak, readonly) DGViewController *debugViewController;

- (void)showDebugBubble;
- (void)removeDebugBubble;
- (void)closeDebugViewControllerContainerWindow;
- (void)removeDebugViewControllerContainerWindow;
- (void)refreshDebugBubble;

///------------------------------------------------
/// Login Bubble
///------------------------------------------------

@property (nonatomic, weak, readonly) DGSuspensionView *loginBubble;
@property (nonatomic, weak, readonly) DGSuspensionContainer *loginViewControllerContainerWindow;

- (void)showLoginBubble;
- (void)removeLoginBubble;
- (void)removeLoginViewControllerContainerWindow;

@end

NS_ASSUME_NONNULL_END
