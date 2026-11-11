//
//  DGEntrance.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGDebugWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGEntrance : NSObject

/// bubble 长按事件
@property (nonatomic, copy) void(^bubbleLongPressBlock)(void);

+ (instancetype)shared;

@property (nonatomic, strong, readonly) DGDebugWindow *debugWindow;

/// 显示悬浮球
- (void)showBubble;

/// 隐藏悬浮球
- (void)hiddenBubble;

/// 关闭 debug window
- (void)closeDebugWindow;

@end

NS_ASSUME_NONNULL_END
