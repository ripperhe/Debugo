//
//  DGActionPluginConfiguration.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/15.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGActionPluginConfiguration : NSObject

/// 添加共享指令，触发后自动关闭 Debug Window
- (void)addCommonActionWithTitle:(NSString *)title handler:(DGActionHandlerBlock)handler;

/// 添加共享指令，通过 autoClose 控制触发后是否自动关闭 Debug Window
- (void)addCommonActionWithTitle:(NSString *)title handler:(DGActionHandlerBlock)handler autoClose:(BOOL)autoClose;

/// 获取所有共享指令；外部一般不需要使用
- (NSArray<DGAction *> *)getAllCommonActions;

@end

NS_ASSUME_NONNULL_END
