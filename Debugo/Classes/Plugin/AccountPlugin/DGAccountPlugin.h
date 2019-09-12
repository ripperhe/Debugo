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
@property (nonatomic, strong, nullable) NSArray <DGAccount *>*currentCommonAccountArray;
@property (nonatomic, strong, nullable) DGOrderedDictionary <NSString *, DGAccount *>*temporaryAccountDic;
@property (nonatomic, strong, readonly) DGWindow *loginWindow;

+ (instancetype)shared;

- (void)setupWithConfiguration:(DGAccountPluginConfiguration *)configuration;

- (void)addAccount:(DGAccount *)account;

@end

NS_ASSUME_NONNULL_END
