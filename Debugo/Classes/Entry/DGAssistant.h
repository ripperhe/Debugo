//
//  DGAssistant.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const DGDebugWindowWillShowNotificationKey;
extern NSString *const DGDebugWindowDidHiddenNotificationKey;

@interface DGAssistant : NSObject

@property (nonatomic, copy) void(^bubbleLongPressBlock)(void);
@property (nonatomic, strong) NSMutableArray *customPlugins;

+ (instancetype)shared;

- (void)setup;

- (void)closeDebugWindow;

@end

NS_ASSUME_NONNULL_END
