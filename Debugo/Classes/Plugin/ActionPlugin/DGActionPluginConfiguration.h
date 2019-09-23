//
//  DGActionPluginConfiguration.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/9/15.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGActionPluginConfiguration : NSObject

/// 设置共享指令
@property (nonatomic, strong) NSArray <DGAction *>*commonActions;

@end

NS_ASSUME_NONNULL_END
