//
//  Debugo.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "Debugo.h"
#import "DGEntrance.h"
#import "DGCommon.h"
#import "DebugoEnable.h"
#import "DGActionPlugin.h"
#import "DGAccountPlugin.h"

@interface Debugo()

@property (nonatomic, assign) BOOL isFire;

@end

@implementation Debugo

static Debugo *_instance = nil;
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

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        printf("[☄️ %s ● %s ● %d] %s ● %s\n", [NSDate date].dg_dateString.UTF8String, ([NSString stringWithFormat:@"%s", __FILE__].lastPathComponent).UTF8String, __LINE__, NSStringFromSelector(_cmd).UTF8String, [[NSString stringWithFormat:@"Debugo canBeEnabled %@", [Debugo canBeEnabled] ? @"✅" : @"❌"] UTF8String]);
    });
}

+ (NSString *)version {
    return @"0.3.0";
}

+ (BOOL)canBeEnabled {
#if DebugoCanBeEnabled
    return YES;
#else
    return NO;
#endif
}

#pragma mark -
+ (void)fireWithConfiguration:(void (^)(DGConfiguration *configuration))block {
    dg_exec_main_queue_only_can_be_enabled(^{
        if (Debugo.shared.isFire) return;
        
        Debugo.shared->_isFire = YES;
        DGConfiguration *configuration = [DGConfiguration new];
        if (block) {
            block(configuration);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 异步启动，为了解决使用 storybroad 自动创建 AppDelegate window 且模拟器启动时为横屏状态会黑屏的问题
            // 可能是 AppDelegate 的 window 还没变成 keyWindow，然后 debugo 内部创建 window 影响到了
            [DGEntrance.shared showBubble];
        });
    });
}

+ (void)closeDebugWindow {
    dg_exec_main_queue_only_can_be_enabled(^{
        if (!Debugo.shared.isFire) return;
        
        [DGEntrance.shared closeDebugWindow];
    });
}

#pragma mark - action plugin

+ (void)addActionWithTitle:(NSString *)title handler:(DGActionHandlerBlock)handler {
    dg_exec_main_queue_only_can_be_enabled(^{
        [DGActionPlugin.shared addActionForUser:nil withTitle:title autoClose:YES handler:handler];
    });
}

+ (void)addActionWithTitle:(NSString *)title handler:(DGActionHandlerBlock)handler autoClose:(BOOL)autoClose {
    dg_exec_main_queue_only_can_be_enabled(^{
        [DGActionPlugin.shared addActionForUser:nil withTitle:title autoClose:autoClose handler:handler];
    });
}

+ (void)addActionForUser:(NSString *)user title:(NSString *)title handler:(DGActionHandlerBlock)handler {
    dg_exec_main_queue_only_can_be_enabled(^{
        [DGActionPlugin.shared addActionForUser:user withTitle:title autoClose:YES handler:handler];
    });
}

+ (void)addActionForUser:(NSString *)user title:(NSString *)title handler:(nonnull DGActionHandlerBlock)handler autoClose:(BOOL)autoClose {
    dg_exec_main_queue_only_can_be_enabled(^{
        [DGActionPlugin.shared addActionForUser:user withTitle:title autoClose:autoClose handler:handler];
    });
}

#pragma mark - account plugin

+ (void)accountPluginAddAccount:(DGAccount *)account {
    dg_exec_main_queue_only_can_be_enabled(^{
        if ([account isKindOfClass:[DGAccount class]] && account.isValid){
            [DGAccountPlugin.shared addAccount:account];
        }else{
            DGLog(@"获取到未知登陆数据 %@", account);
        }
    });
}

@end

@implementation Debugo (Additional)

+ (void)executeCodeForUser:(NSString *)user handler:(void (NS_NOESCAPE ^)(void))handler {
    if (![self canBeEnabled]) return;
    dg_exec(user, handler);
}

+ (UIViewController *)topViewController {
    return dg_topViewController();
}

+ (UIViewController *)topViewControllerForWindow:(UIWindow *)window {
    return dg_topViewControllerForWindow(window);
}

+ (UIWindow *)keyboardWindow {
    return dg_keyboardWindow();
}

+ (NSArray <UIWindow *>*)getAllWindows {
    return dg_getAllWindows();
}

@end
