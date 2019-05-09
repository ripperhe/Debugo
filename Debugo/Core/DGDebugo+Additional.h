//
//  DGDebugo+Additional.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGDebugo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGDebugo (Additional)

/** 获取 [UIApplication sharedApplication].delegate.window 的顶部控制器 */
+ (nullable UIViewController *)topViewController;

/** 获取一个 window 顶部的 viewController; 传 nil 则取 [UIApplication sharedApplication].delegate.window */
+ (nullable UIViewController *)topViewControllerForWindow:(nullable UIWindow *)window;

/** 获取 [UIApplication sharedApplication].windows 中最上层的、可见的、全屏 window */
+ (nullable UIWindow *)topVisibleFullScreenWindow;

/** 获取可见的键盘 window */
+ (nullable UIWindow *)keyboardWindow;

/** 获取所有 window, 包括系统内部的 window, 例如状态栏... (⚠️ 建议仅在 DEBUG 模式使用) */
+ (nullable NSArray <UIWindow *>*)getAllWindows;

@end

NS_ASSUME_NONNULL_END
