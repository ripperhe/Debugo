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

void debugo_exec_main_queue(void (^handler)(void)) {
#if DebugoCanBeEnabled
    dg_dispatch_main_async_safe(handler);
#endif
}

NSString * debugo_current_user() {
    static NSString *_currentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [NSString stringWithFormat:@"%s", __FILE__];
        if ([path hasPrefix:@"/Users/"]) {
            NSArray *components = [path componentsSeparatedByString:@"/"];
            if (components.count > 3) {
                _currentUser = components[2];
            }
        }
        NSLog(@"debugo_current_user: %@", _currentUser);
    });
    return _currentUser;
}

#if DebugoCanBeEnabled
void debugo_exec(NSString *user, void (NS_NOESCAPE ^handler)(void)) {
    NSString *currentUser = debugo_current_user();
    if (!currentUser.length || !user.length) return;
    if (![currentUser isEqualToString:user]) return;
    
    if (handler) {
        handler();
    }
}
#endif


NSString *const DGDebugoDidLoginSuccessNotification = @"DGDebugoDidLoginSuccessNotification";
NSString *const DGDebugoDidLogoutSuccessNotification = @"DGDebugoDidLogoutSuccessNotification";

@implementation DGDebugo

+ (void)load {
#if DebugoCanBeEnabled
    printf("☄️ DebugoCanBeEnabled ✅\n");
#else
    printf("☄️ DebugoCanBeEnabled ❌\n");
#endif
    
//#if DGDebuggingOverlayCanBeEnabled
//    printf("• DGDebuggingOverlayCanBeEnabled ✅\n");
//#else
//    printf("• DGDebuggingOverlayCanBeEnabled ❌\n");
//#endif
//
//#if DGSuspensionViewCanBeEnabled
//    printf("• DGSuspensionViewCanBeEnabled ✅\n");
//#else
//    printf("• DGSuspensionViewCanBeEnabled ❌\n");
//#endif
//
//#if DGTouchMonitorCanBeEnabled
//    printf("• DGTouchMonitorCanBeEnabled ✅\n");
//#else
//    printf("• DGTouchMonitorCanBeEnabled ❌\n");
//#endif
}

static DGDebugo *_instance = nil;
+ (instancetype)shared
{
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
#if DebugoCanBeEnabled
        // notification
        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(loginSuccessNotification:) name:DGDebugoDidLoginSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(logoutSuccessNotification:) name:DGDebugoDidLogoutSuccessNotification object:nil];
#endif
    });
    return _instance;
}

#pragma mark - getter
- (NSString *)currentUser {
    return debugo_current_user();
}

#pragma mark -
+ (void)fireWithConfiguration:(void (^)(DGConfiguration *configuration))configurationHandler
{
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

+ (void)stop
{
    debugo_exec_main_queue(^{
        if (!DGDebugo.shared.isFire) return;
        
        DGDebugo.shared->_isFire = NO;
        [DGAssistant.shared reset];
    });
}

+ (void)closeDebugWindow {
    debugo_exec_main_queue(^{
        if (!DGDebugo.shared.isFire) return;
        [DGAssistant.shared closeDebugViewControllerContainerWindow];
    });
}

#pragma mark - test action

+ (void)addTestActionForUser:(NSString *)user title:(NSString *)title autoClose:(BOOL)autoClose handler:(DGTestActionHandlerBlock)handler
{
    debugo_exec_main_queue(^{
        [DGAssistant.shared addTestActionForUser:user withTitle:title autoClose:autoClose handler:handler];
    });
}

+ (void)addTestActionWithTitle:(NSString *)title autoClose:(BOOL)autoClose handler:(DGTestActionHandlerBlock)handler
{
    debugo_exec_main_queue(^{
        [DGAssistant.shared addTestActionForUser:nil withTitle:title autoClose:autoClose handler:handler];
    });
}

+ (void)addTestActionWithTitle:(NSString *)title handler:(DGTestActionHandlerBlock)handler
{
    debugo_exec_main_queue(^{
        [DGAssistant.shared addTestActionForUser:nil withTitle:title autoClose:YES handler:handler];
    });
}

#pragma mark - notification
- (void)loginSuccessNotification:(NSNotification *)notification
{
    debugo_exec_main_queue(^{
        if (!self.isFire) return;
        if (!DGAssistant.shared.configuration.needLoginBubble) return;
        
        NSObject *obj = notification.object;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            // 字典类型 {username:password}
            NSDictionary *dic = (NSDictionary *)obj;
            if (dic.allKeys.count == 1) {
                NSString *username = dic.allKeys.firstObject;
                NSString *password = [dic objectForKey:username];
                [DGAssistant.shared addAccountWithUsername:username password:password];
            }
        }else if ([obj isKindOfClass:[DGAccount class]]){
            // DGAccount 类型
            DGAccount *account = (DGAccount *)obj;
            [DGAssistant.shared addAccountWithUsername:account.username password:account.password];
        }else{
            NSLog(@"Debugo: 从通知获取到未知登陆数据");
        }
        
        [DGAssistant.shared removeLoginBubble];
    });
}

- (void)logoutSuccessNotification:(NSNotification *)notification
{
    debugo_exec_main_queue(^{
        if (!self.isFire) return;
        if (!DGAssistant.shared.configuration.needLoginBubble) return;
        
        [DGAssistant.shared showLoginBubble];
    });
}

@end
