//
//  DGAccountPlugin.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPlugin.h"
#import "DGCommon.h"
#import "DGBubble.h"
#import "DGAccountPluginConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGAccountPlugin : DGPlugin

@property (nonatomic, strong) DGAccountPluginConfiguration *configuration;
@property (nonatomic, strong, nullable) DGOrderedDictionary<NSString *, DGAccount *> *cacheAccountDic;

+ (instancetype)shared;

- (NSArray<DGAccount *> *)currentCommonAccountArray;

- (void)addAccount:(DGAccount *)account;

@end

NS_ASSUME_NONNULL_END
