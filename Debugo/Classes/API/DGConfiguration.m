//
//  DGConfiguration.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "DGConfiguration.h"
#import "DGAssistant.h"
#import "DGActionPlugin.h"
#import "DGFilePlugin.h"
#import "DGAccountPlugin.h"

@implementation DGConfiguration

- (void)setupBubbleLongPressAction:(void (^)(void))block {
    if (block) {
        DGAssistant.shared.bubbleLongPressBlock = block;
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

- (void)addCustomPlugin:(Class)plugin {
    if (![plugin conformsToProtocol:@protocol(DGPluginProtocol)]) {
        return;
    }
    [DGAssistant.shared.customPlugins addObject:plugin];
}

@end
