//
//  DGDatabasePreviewConfiguration.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/16.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGDatabasePreviewConfiguration.h"

// #define isValidRowHeight(h) (h>=30.0&&h<=100.0?YES:NO)
#define isValidColumnWidth(w) (w>=50.0&&w<=1000.0?YES:NO)
#define checkColumnAndReturn(columnWidth) \
if (!isValidColumnWidth(columnWidth)) { \
NSAssert(0, @"DGFilePlugin: 请给出合理的列宽 [50, 1000]"); \
return; \
}

static CGFloat kDefaultColumnWidth = 100.0;

@interface DGDatabasePreviewConfiguration ()

@property (nonatomic, assign) CGFloat commonWidth;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *commonWidthForTable;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSNumber *> *> *specialWidthDicForTable;

@end

@implementation DGDatabasePreviewConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        self.commonWidth = kDefaultColumnWidth;
        self.commonWidthForTable = [NSMutableDictionary dictionary];
        self.specialWidthDicForTable = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setCommonColumnWidth:(CGFloat)columnWidth {
    checkColumnAndReturn(columnWidth)
    self.commonWidth = columnWidth;
}

- (void)setCommonColumnWidth:(CGFloat)columnWidth forTable:(NSString *)tableName {
    if (!tableName.length) return;
    checkColumnAndReturn(columnWidth)
    [self.commonWidthForTable setObject:@(columnWidth) forKey:tableName];
}

- (void)setSpecialColumnWidthDictionary:(NSDictionary<NSString *,NSNumber *> *)columnNameToWidth forTable:(NSString *)tableName {
    if (!tableName.length || !columnNameToWidth.count) return;
    for (NSNumber *width in columnNameToWidth.allValues) {
        checkColumnAndReturn(width.floatValue)
    }
    NSMutableDictionary *dic = [self.specialWidthDicForTable objectForKey:tableName];
    if (dic) {
        [dic addEntriesFromDictionary:columnNameToWidth];
    }else {
        [self.specialWidthDicForTable setObject:columnNameToWidth.mutableCopy forKey:tableName];
    }
}

- (CGFloat)columnWidthForTable:(NSString *)tableName column:(NSString *)columnName {
    if (!tableName.length || !columnName.length) return self.commonWidth;
    NSDictionary *specialDic = [self.specialWidthDicForTable objectForKey:tableName];
    if (specialDic) {
        NSNumber *columnWidth = [specialDic objectForKey:columnName];
        if (columnWidth) {
            return columnWidth.floatValue;
        }
    }
    NSNumber *commonForTable = [self.commonWidthForTable objectForKey:tableName];
    if (commonForTable) {
        return commonForTable.floatValue;
    }
    return self.commonWidth;
}

@end
