//
//  DGDebugo.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "DGDebugo.h"
#import "DGAssistant.h"
#import "DebugoEnable.h"
#import "DGActionManager.h"
#import "DGAccountManager.h"

void debugo_exec_main_queue(void (^handler)(void)) {
#if DebugoCanBeEnabled
    dg_dispatch_main_safe(handler);
#endif
}

#if DebugoCanBeEnabled
void debugo_exec(NSString *user, void (NS_NOESCAPE ^handler)(void)) {
    NSString *currentUser = dg_current_user();
    if (!currentUser.length || !user.length) return;
    if (![currentUser isEqualToString:user]) return;
    
    if (handler) {
        handler();
    }
}
#endif

@interface DGDebugo()
@property (nonatomic, assign) BOOL isFire;
@end

@implementation DGDebugo

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        printf("[☄️ %s ● %s ● %d] %s ● %s\n", [NSDate date].dg_dateString.UTF8String, ([NSString stringWithFormat:@"%s", __FILE__].lastPathComponent).UTF8String, __LINE__, NSStringFromSelector(_cmd).UTF8String, [[NSString stringWithFormat:@"Debugo canBeEnabled %@\n", [DGDebugo canBeEnabled] ? @"✅" : @"❌"] UTF8String]);
    });
}

+ (BOOL)canBeEnabled {
#if DebugoCanBeEnabled
    return YES;
#else
    return NO;
#endif
}

static DGDebugo *_instance = nil;
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

#pragma mark -
+ (void)fireWithConfiguration:(void (^)(DGConfiguration *configuration))configurationHandler {
    debugo_exec_main_queue(^{
        if (DGDebugo.shared.isFire) return;
        
        DGDebugo.shared->_isFire = YES;
        DGConfiguration *configuration = [DGConfiguration new];
        if (configurationHandler) {
            configurationHandler(configuration);
        }
        [DGAssistant.shared setupWithConfiguration:configuration];
    });
}

//+ (void)stop {
//    debugo_exec_main_queue(^{
//        if (!DGDebugo.shared.isFire) return;
//
//        DGDebugo.shared->_isFire = NO;
//        [DGAssistant.shared reset];
//    });
//}

+ (void)closeDebugWindow {
    debugo_exec_main_queue(^{
        if (!DGDebugo.shared.isFire) return;
        
        [DGAssistant.shared closeDebugWindow];
    });
}

#pragma mark - action

+ (void)addActionWithTitle:(NSString *)title handler:(DGActionHandlerBlock)handler {
    debugo_exec_main_queue(^{
        [DGActionManager.shared addActionForUser:nil withTitle:title autoClose:YES handler:handler];
    });
}

+ (void)addActionForUser:(NSString *)user title:(NSString *)title handler:(DGActionHandlerBlock)handler {
    debugo_exec_main_queue(^{
        [DGActionManager.shared addActionForUser:user withTitle:title autoClose:YES handler:handler];
    });
}

+ (void)addActionForUser:(NSString *)user title:(NSString *)title autoClose:(BOOL)autoClose handler:(DGActionHandlerBlock)handler {
    debugo_exec_main_queue(^{
        [DGActionManager.shared addActionForUser:user withTitle:title autoClose:autoClose handler:handler];
    });
}

#pragma mark - quick login

+ (void)loginSuccessWithAccount:(DGAccount *)account {
    debugo_exec_main_queue(^{
        if (!DGDebugo.shared.isFire) return;
        if (!DGAccountManager.shared.configuration.needLoginBubble) return;
        
        if ([account isKindOfClass:[DGAccount class]] && account.isValid){
            [DGAccountManager.shared addAccount:account];
        }else{
            DGLog(@"Debugo: 从通知获取到未知登陆数据 %@", account);
        }
        
        [DGAccountManager.shared removeLoginBubble];
    });
}

+ (void)logoutSuccess {
    debugo_exec_main_queue(^{
        if (!DGDebugo.shared.isFire) return;
        if (!DGAccountManager.shared.configuration.needLoginBubble) return;
        
        [DGAccountManager.shared showLoginBubble];
    });
}

@end
