//
//  DGCurrentUser.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGDevice.h"

#define kDGScreenW ([UIScreen mainScreen].bounds.size.width)
#define kDGScreenH ([UIScreen mainScreen].bounds.size.height)

#define kDGScreenMin MIN(kDGScreenW, kDGScreenH)
#define kDGScreenMax MAX(kDGScreenW, kDGScreenH)

#define kDGStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define kDGBottomSafeMargin (([DGDevice currentDevice].isNotchUI) ? 34.0 : 0.0)

#define kDGHighlightColor [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0]

#define kDGImpactFeedback \
if (@available(iOS 10.0, *)) { \
UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium]; \
[feedBackGenertor impactOccurred]; \
}

/** 弱引用 */
#define dg_weakify(var) __weak typeof(var) dg_weak_##var = var;
/** 强引用 */
#define dg_strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = dg_weak_##var; \
_Pragma("clang diagnostic pop")

/** 获取当前电脑用户 */
NSString * dg_current_user(void);

/** 当前主线程，同步执行；当前非主线程，异步执行 */
void dg_dispatch_main_safe(void(^block)(void));

