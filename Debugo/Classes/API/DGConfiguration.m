//
//  DGConfiguration.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGConfiguration.h"
#import "DGEntrance.h"
#import "DGPluginManager.h"

@implementation DGConfiguration

- (void)addCustomPlugin:(Class<DGPluginProtocol>)plugin {
    [DGPluginManager.shared addCustomPlugin:plugin];
}

- (void)putPluginsToTabBar:(NSArray<Class<DGPluginProtocol>> *)plugins {
    [DGPluginManager.shared putPluginsToTabBar:plugins];
}

- (void)setupBubbleLongPressAction:(void (^)(void))block {
    if (block) {
        DGEntrance.shared.bubbleLongPressBlock = block;
    }
}

- (void)setupActionPlugin:(void (^)(DGActionPluginConfiguration * _Nonnull))block {
    DGActionPluginConfiguration *configuration = [DGActionPluginConfiguration new];
    if (block) {
        block(configuration);
    }
    DGActionPlugin.shared.configuration = configuration;
}

- (void)setupFilePlugin:(void (^)(DGFilePluginConfiguration * _Nonnull))block {
    DGFilePluginConfiguration *configuration = [DGFilePluginConfiguration new];
    if (block) {
        block(configuration);
    }
    DGFilePlugin.shared.configuration = configuration;
}

- (void)setupAccountPlugin:(void (^)(DGAccountPluginConfiguration * _Nonnull))block {
    DGAccountPluginConfiguration *configuration = [DGAccountPluginConfiguration new];
    if (block) {
        block(configuration);
    }
    DGAccountPlugin.shared.configuration = configuration;
}

- (void)setupPodPlugin:(void (^)(DGPodPluginConfiguration * _Nonnull))block {
    DGPodPluginConfiguration *configuration = [DGPodPluginConfiguration new];
    if (block) {
        block(configuration);
    }
    DGPodPlugin.shared.configuration = configuration;
}

@end
