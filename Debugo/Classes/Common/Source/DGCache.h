//
//  DGCache.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGPlister.h"

@interface DGCache : NSObject

/// 缓存文件夹
@property (nonatomic, copy) NSString *debugoPath;

/// 缓存账号的plist文件
@property (nonatomic, strong, readonly) DGPlister *accountPlister;

+ (instancetype)shared;

@end
