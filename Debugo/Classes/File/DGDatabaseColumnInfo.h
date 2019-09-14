//
//  DGDatabaseColumnInfo.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGDatabaseColumnInfo : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger notnull;
@property (nonatomic, strong) id dflt_value;
@property (nonatomic, assign) NSInteger pk;

@end

NS_ASSUME_NONNULL_END
