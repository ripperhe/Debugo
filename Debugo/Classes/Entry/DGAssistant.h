//
//  DGAssistant.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGAssistant : NSObject

@property (nonatomic, copy) void(^bubbleLongPressBlock)(void);
@property (nonatomic, strong) NSArray<Class<DGPluginProtocol>> *debugoPlugins;
@property (nonatomic, strong) NSMutableArray<Class<DGPluginProtocol>> *customPlugins;
@property (nonatomic, strong) NSMutableArray<Class<DGPluginProtocol>> *tabBarPlugins;

+ (instancetype)shared;

- (void)showBubble;

- (void)closeDebugWindow;

@end

NS_ASSUME_NONNULL_END
