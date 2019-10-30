//
//  DGPluginManager.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/10/30.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGActionPlugin.h"
#import "DGFilePlugin.h"
#import "DGAppInfoPlugin.h"
#import "DGAccountPlugin.h"
#import "DGApplePlugin.h"
#import "DGTouchPlugin.h"
#import "DGColorPlugin.h"
#import "DGPodPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGPluginManager : NSObject

/// debugo 自带的工具
@property (nonatomic, strong) NSArray<Class<DGPluginProtocol>> *debugoPlugins;
/// 自定义工具
@property (nonatomic, strong) NSMutableArray<Class<DGPluginProtocol>> *customPlugins;
/// 放在 tabBar 的工具
@property (nonatomic, strong) NSMutableArray<Class<DGPluginProtocol>> *tabBarPlugins;

+ (instancetype)shared;

- (void)addCustomPlugin:(Class<DGPluginProtocol>)plugin;

- (void)putPluginsToTabBar:(nullable NSArray<Class<DGPluginProtocol>> *)plugins;

@end

NS_ASSUME_NONNULL_END
