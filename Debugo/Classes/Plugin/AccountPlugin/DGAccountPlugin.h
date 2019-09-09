//
//  DGAccountPlugin.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCommon.h"
#import "DGBubble.h"
#import "DGAccountPluginConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGAccountPlugin : NSObject

@property (nonatomic, strong) DGAccountPluginConfiguration *configuration;
@property (nonatomic, strong, nullable) NSArray <DGAccount *>*currentCommonAccountArray;
@property (nonatomic, strong, nullable) DGOrderedDictionary <NSString *, DGAccount *>*temporaryAccountDic;

@property (nonatomic, strong, readonly) DGWindow *loginWindow;

+ (instancetype)shared;

- (void)setupWithConfiguration:(DGAccountPluginConfiguration *)configuration;

- (void)reset;

- (void)addAccount:(DGAccount *)account;

- (void)showLoginWindow;

- (void)removeLoginWindow;
@end

NS_ASSUME_NONNULL_END
