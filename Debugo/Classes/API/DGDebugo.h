//
//  DGDebugo.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DebugoEnable.h"
#import "DGConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

#if DebugoCanBeEnabled
/** 仅在该 user 的电脑上执行 block 中的代码 (`$ whoami`) */
void debugo_exec(NSString *user, void (NS_NOESCAPE ^handler)(void));
#else
#define debugo_exec(...)
#endif

@interface DGDebugo : NSObject

+ (BOOL)canBeEnabled;

/** ☄️ 启动框架 可在 configuration block 中配置参数 */
+ (void)fireWithConfiguration:(nullable void (^)(DGConfiguration *configuration))configuration;

+ (void)closeDebugWindow;

+ (void)addActionWithTitle:(NSString *)title handler:(DGActionHandlerBlock)handler;

+ (void)addActionForUser:(nullable NSString *)user title:(NSString *)title handler:(DGActionHandlerBlock)handler;

+ (void)addActionForUser:(nullable NSString *)user title:(NSString *)title autoClose:(BOOL)autoClose handler:(DGActionHandlerBlock)handler;

+ (void)accountPluginAddAccount:(DGAccount *)account;

@end

NS_ASSUME_NONNULL_END
