//
//  DGTestAction.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import <UIKit/UIKit.h>
@class DGTestAction;

NS_ASSUME_NONNULL_BEGIN

typedef void(^DGTestActionHandlerBlock)(DGTestAction *action, UIViewController *actionVC);

@interface DGTestAction : NSObject

/** Action 的标题，即 cell title */
@property (nonatomic, copy) NSString *title;
/** 点击执行 Action 后是否自动关闭 */
@property (nonatomic, assign) BOOL autoClose;
/** 实际执行的代码 */
@property (nonatomic, copy) DGTestActionHandlerBlock handler;
/** 当前 Action 归属于哪个使用者 */
@property (nonatomic, copy) NSString *user;

+ (instancetype)actionWithTitle:(NSString *)title autoClose:(BOOL)autoClose handler:(DGTestActionHandlerBlock)handler;
- (BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
