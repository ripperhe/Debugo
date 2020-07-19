//
//  DGCurrentUser.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DebugoEnable.h"
#import "DGDevice.h"
#import "NSDate+Debugo.h"

NS_ASSUME_NONNULL_BEGIN

#if DebugoCanBeEnabled
#define DGLog(format, ...)  do { printf("[☄️ %s ● %s ● %d] %s ● %s\n", [NSDate date].dg_dateString.UTF8String, ([NSString stringWithFormat:@"%s", __FILE__].lastPathComponent).UTF8String, __LINE__, NSStringFromSelector(_cmd).UTF8String, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);} while (0)
#define DGCLog(format, ...)  do { printf("[☄️ %s ● %s ● %d] %s ● %s\n", [NSDate date].dg_dateString.UTF8String, ([NSString stringWithFormat:@"%s", __FILE__].lastPathComponent).UTF8String, __LINE__, __func__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);} while (0)
#else
#define DGLog(...)
#define DGCLog(...)
#endif

#define DGLogSelf DGLog(@"%@", self)
#define DGLogFunction DGLog(@"")

#define kDGScreenW ([UIScreen mainScreen].bounds.size.width)
#define kDGScreenH ([UIScreen mainScreen].bounds.size.height)

#define kDGScreenMin MIN(kDGScreenW, kDGScreenH)
#define kDGScreenMax MAX(kDGScreenW, kDGScreenH)

#define kDGStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define kDGBottomSafeMargin (([DGDevice currentDevice].isNotchUI) ? 34.0 : 0.0)
#define kDGNavigationTotalHeight (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)

#define kDGBackgroundColor [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00]
#define kDGHighlightColor [UIColor colorWithRed:0.00 green:0.478431 blue:1.00 alpha:1.00]

#define kDGImpactFeedback \
if (@available(iOS 10.0, *)) { \
UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium]; \
[feedBackGenertor impactOccurred]; \
}

#define dg_weakify(var) __weak typeof(var) dg_weak_##var = var;
#define dg_strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = dg_weak_##var; \
_Pragma("clang diagnostic pop")

/// 获取当前电脑用户
NSString * dg_current_user(void);

/// 仅在某用户编译的安装包上执行某些代码
/// @param user 用户名
/// @param handler 代码
void dg_exec(NSString *user, void (NS_NOESCAPE ^handler)(void));

/// 当前主线程，同步执行；当前非主线程，异步执行
/// @param block 需要执行的代码
void dg_dispatch_main_safe(void(^block)(void));

/// 运行时执行方法，如果没有则不执行，支持大部分参数类型，不支持会断言
/// @param any 类或者对象
/// @param selector 方法选择器
/// @param args 参数数组，如果没有参数传nil，如果中间某个参数为nil则传NSNull占位
/// @return 方法返回值，没有返回值则为nil
id dg_invoke(id any, SEL selector, NSArray * _Nullable args);

/// 在DebugoCanBeEnabled的时候，在主线程执行对应代码，否则不执行
/// @param block 需要执行的代码
#if DebugoCanBeEnabled
void dg_exec_main_queue_only_can_be_enabled(void (^block)(void));
#else
#define dg_exec_main_queue_only_can_be_enabled(...)
#endif

/// 获取主 winow 的顶部控制器
UIViewController * dg_topViewController(void);

/// 获取某个 window 顶部的 viewController
UIViewController * dg_topViewControllerForWindow(UIWindow * _Nullable window);

/// 获取主 window scene; (仅iOS13有效，可能为空)
id dg_mainWindowScene(void);

/// 获取主 window
UIWindow *dg_mainWindow(void);

/// 获取顶部的全屏的 window
UIWindow * dg_topVisibleFullScreenWindow(void);

/// 获取可见的键盘 window
UIWindow * dg_keyboardWindow(void);

/// 获取所有 window, 包括系统内部的 window, 例如状态栏...
NSArray<UIWindow *> * dg_getAllWindows(void);

/// 解决中文乱码问题
NSString * dg_description(id<NSObject> obj);

NS_ASSUME_NONNULL_END
