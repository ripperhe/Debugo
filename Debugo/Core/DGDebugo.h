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
#import "DGDatabasePreviewConfiguration.h"
@class DGDebugo;

NS_ASSUME_NONNULL_BEGIN

#if DebugoCanBeEnabled
// 仅在该 user 的电脑上执行 block 中的代码 (`$ whoami`)
void debugo_exec(NSString *user, void (NS_NOESCAPE ^handler)(void));
#else
#define debugo_exec(...)
#endif


///------------------------------------------------
/// Notification
///------------------------------------------------

// 如果使用 login bubble 快速登陆，在登陆成功时发送该通知；用于隐藏 login bubble 以及存储账号
extern NSString *const DGDebugoDidLoginSuccessNotification;
// 退出登陆成功时发送本通知；用于重新显示 login bubble
extern NSString *const DGDebugoDidLogoutSuccessNotification;


///------------------------------------------------
/// DGDebugoDelegate
///------------------------------------------------

@protocol DGDebugoDelegate <NSObject>

@optional

/** 自定义 test action viewController 的 tableHeaderView; 这是我特意留给你的一亩三分地，可用于显示当前账号等信息~ 🤩  */
- (nullable UIView *)debugoTestActionViewControllerTableHeaderView;
/** 使用 login bubble 选中列表中的某个账号时，会调用这个代理方法，并传回账号信息，你需要在这个代理方法实现自动登录 */
- (void)debugoLoginAccount:(DGAccount *)account;
/** 需要自行控制显示数据库文件的表的行高、列宽的时候需要实现该代理方法 */
- (nullable DGDatabasePreviewConfiguration *)debugoDatabasePreviewConfigurationForDatabaseURL:(NSURL *)databaseURL;

@end


///------------------------------------------------
/// DGDebugo
///------------------------------------------------

@interface DGDebugo : NSObject

@property (nonatomic, weak, nullable) id<DGDebugoDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isFire;
@property (nonatomic, copy, readonly, nullable) NSString *currentUser;

+ (instancetype)shared;

/** ☄️ 启动框架 可在 configuration block 中配置参数 */
+ (void)fireWithConfiguration:(nullable void (^)(DGConfiguration *configuration))configuration;
/** 💥 停用框架 */
+ (void)stop;

+ (void)closeDebugWindow;

+ (void)addTestActionForUser:(nullable NSString *)user title:(NSString *)title autoClose:(BOOL)autoClose handler:(DGTestActionHandlerBlock)handler;

+ (void)addTestActionWithTitle:(NSString *)title autoClose:(BOOL)autoClose handler:(DGTestActionHandlerBlock)handler;

+ (void)addTestActionWithTitle:(NSString *)title handler:(DGTestActionHandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
