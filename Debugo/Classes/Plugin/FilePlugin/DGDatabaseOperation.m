//
//  DGDatabaseOperation.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGDatabaseOperation.h"
#if __has_include(<fmdb/FMDB.h>)
    #import <fmdb/FMDB.h>
#else
    #import "FMDB.h"
#endif

@interface DGDatabaseOperation ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation DGDatabaseOperation

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        // 防止在没有数据库文件的情况下，自动创建数据库
        if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
            self.queue = [FMDatabaseQueue databaseQueueWithURL:url];
        }
    }
    return self;
}

- (instancetype)initWithDBQueue:(FMDatabaseQueue *)dbQueue {
    if (self = [super init]) {
        self.queue = dbQueue;
    }
    return self;
}

- (NSArray <DGDatabaseTableInfo *>*)queryAllTableInfo {
    __block NSMutableArray *tableInfos = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        
        NSString *sql = @"SELECT type, name, tbl_name, rootpage, sql FROM (SELECT * FROM sqlite_master UNION ALL SELECT * FROM sqlite_temp_master) WHERE type = 'table' ORDER BY tbl_name, name";
        FMResultSet *set = [db executeQuery:sql];
        while (set.next) {
            DGDatabaseTableInfo *table = [DGDatabaseTableInfo new];
            [table setValuesForKeysWithDictionary:set.resultDictionary];
            [tableInfos addObject:table];
        }
        [set close];
    }];
    return tableInfos;
}

- (NSArray <DGDatabaseColumnInfo *>*)queryAllColumnInfoForTable:(DGDatabaseTableInfo *)table {
    __block NSMutableArray *columnInfos = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        
        FMResultSet *set = [db getTableSchema:table.name];
        while (set.next) {
            DGDatabaseColumnInfo *column = [DGDatabaseColumnInfo new];
            [column setValuesForKeysWithDictionary:set.resultDictionary];
            [columnInfos addObject:column];
        }
        [set close];
    }];
    return columnInfos;
}

- (NSArray *)queryAllContentForTable:(DGDatabaseTableInfo *)table {
    __block NSMutableArray *contents = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@", table.name]];
        while (set.next) {
            [contents addObject:set.resultDictionary];
        }
        [set close];
    }];
    return contents;
}

@end
