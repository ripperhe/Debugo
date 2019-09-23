//
//  DGActionPlugin.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGPlugin.h"
#import "DGActionPluginConfiguration.h"
#import "DGOrderedDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGActionPlugin : DGPlugin

@property (nonatomic, strong) DGActionPluginConfiguration *configuration;

@property (nonatomic, strong, nullable) DGOrderedDictionary <NSString *, DGAction *>*anonymousActionDic;

@property (nonatomic, strong, nullable) NSMutableDictionary <NSString *, DGOrderedDictionary <NSString *, DGAction *>*>*usersActionsDic;

+ (instancetype)shared;

- (void)addActionForUser:(nullable NSString *)user withTitle:(NSString *)title autoClose:(BOOL)autoClose handler:(DGActionHandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
