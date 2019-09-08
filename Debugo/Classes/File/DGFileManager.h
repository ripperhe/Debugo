//
//  DGFileManager.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGFileDisplayConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGFileManager : NSObject

@property (nonatomic, strong) DGFileDisplayConfiguration *configuration;

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
