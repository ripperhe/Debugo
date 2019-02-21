//
//  DGDatabaseOperation.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGDatabaseTableInfo.h"
#import "DGDatabaseColumnInfo.h"
@class FMDatabaseQueue;

NS_ASSUME_NONNULL_BEGIN

@interface DGDatabaseOperation : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithDBQueue:(FMDatabaseQueue *)dbQueue;

- (NSArray <DGDatabaseTableInfo *>*)queryAllTableInfo;
- (NSArray <DGDatabaseColumnInfo *>*)queryAllColumnInfoForTable:(DGDatabaseTableInfo *)table;
- (NSArray *)queryAllContentForTable:(DGDatabaseTableInfo *)table;


@end

NS_ASSUME_NONNULL_END
