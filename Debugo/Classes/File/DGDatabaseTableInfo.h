//
//  DGDatabaseTableInfo.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGDatabaseTableInfo : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tbl_name;
@property (nonatomic, assign) NSInteger rootpage;
@property (nonatomic, copy) NSString *sql;

@end

NS_ASSUME_NONNULL_END
