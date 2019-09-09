//
//  DGAccountManager.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCommon.h"
#import "DGBubble.h"
#import "DGAccountConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGAccountManager : NSObject

@property (nonatomic, strong) DGAccountConfiguration *configuration;

@property (nonatomic, strong, nullable) NSArray <DGAccount *>*currentCommonAccountArray;
@property (nonatomic, strong, nullable) DGOrderedDictionary <NSString *, DGAccount *>*temporaryAccountDic;


+ (instancetype)shared;

- (void)setupWithConfiguration:(DGAccountConfiguration *)configuration;

- (void)reset;

- (void)addAccount:(DGAccount *)account;


@property (nonatomic, weak, readonly) DGBubble *loginBubble;
@property (nonatomic, strong, readonly) DGWindow *loginWindow;

- (void)showLoginBubble;
- (void)removeLoginBubble;

- (void)showLoginWindow;
- (void)removeLoginWindow;
@end

NS_ASSUME_NONNULL_END
