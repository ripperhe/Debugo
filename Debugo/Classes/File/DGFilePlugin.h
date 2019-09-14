//
//  DGFilePlugin.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPlugin.h"
#import "DGFilePluginConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGFilePlugin : DGPlugin

@property (nonatomic, strong) DGFilePluginConfiguration *configuration;

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
