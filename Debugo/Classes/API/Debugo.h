//
//  Debugo.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DebugoEnable.h"
#import "DGConfiguration.h"
#import "DGTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface Debugo : NSObject

/// 框架版本
+ (NSString *)version;

/// 框架是否可以启用，目前默认为仅在 DEBUG 模式可以启用
+ (BOOL)canBeEnabled;

/// ☄️ 启动框架 可在 configuration block 中配置参数
+ (void)fireWithConfiguration:(nullable void (^)(DGConfiguration *configuration))block;

/// 关闭 Debug Window
+ (void)closeDebugWindow;

/// 指令：添加匿名指令，触发后自动关闭 Debug Window
+ (void)addActionWithTitle:(NSString *)title handler:(DGActionHandlerBlock)handler;

/// 指令：添加匿名指令，通过 autoClose 控制触发后是否自动关闭 Debug Window
+ (void)addActionWithTitle:(NSString *)title handler:(DGActionHandlerBlock)handler autoClose:(BOOL)autoClose;

/// 指令：为某个用户添加指令，触发后自动关闭 Debug Window
+ (void)addActionForUser:(nullable NSString *)user title:(NSString *)title handler:(DGActionHandlerBlock)handler;

/// 指令：为某个用户添加指令，通过 autoClose 控制触发后是否自动关闭 Debug Window
+ (void)addActionForUser:(nullable NSString *)user title:(NSString *)title handler:(DGActionHandlerBlock)handler autoClose:(BOOL)autoClose;

/// 快速登录：缓存账号
+ (void)accountPluginAddAccount:(DGAccount *)account;

@end

///------------------------------------------------
/// ⚠️ 以下为一些用于调试的实用方法，请勿用于正式业务代码中
///------------------------------------------------

@interface Debugo (Additional)

/// 仅在某个用户的电脑编译的包中立即执行某些代码（canBeEnabled 为 NO 时，则统统不执行）`$ whoami`
+ (void)executeCodeForUser:(NSString *)user handler:(void (NS_NOESCAPE ^)(void))handler;

/// 获取主 window 的顶部控制器
+ (nullable UIViewController *)topViewController;

/// 获取某个 window 顶部的 viewController
+ (nullable UIViewController *)topViewControllerForWindow:(nullable UIWindow *)window;

/// 获取可见的键盘 window
+ (nullable UIWindow *)keyboardWindow;

/// 获取所有 window, 包括系统内部的 window, 例如状态栏...
+ (nullable NSArray <UIWindow *>*)getAllWindows;

@end


NS_ASSUME_NONNULL_END
