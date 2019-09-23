//
//  DGAction.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <UIKit/UIKit.h>
@class DGAction;

NS_ASSUME_NONNULL_BEGIN

typedef void(^DGActionHandlerBlock)(DGAction *action);

@interface DGAction : NSObject

/** action 的标题，即 cell title */
@property (nonatomic, copy) NSString *title;
/** 点击执行 Action 后是否自动关闭 */
@property (nonatomic, assign) BOOL autoClose;
/** 实际执行的代码 */
@property (nonatomic, copy) DGActionHandlerBlock handler;
/** 当前 action 归属于哪个使用者 */
@property (nonatomic, copy) NSString *user;
/** 触发当前 action 的控制器，可以用来推出页面 */
@property (nonatomic, weak) UIViewController *viewController;

+ (instancetype)actionWithTitle:(NSString *)title autoClose:(BOOL)autoClose handler:(DGActionHandlerBlock)handler;
- (BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
