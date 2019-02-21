//
//  DGDatabaseUIConfig.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/16.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGDatabaseUIConfig.h"

#define isValidRowHeight(h) (h>=30.0&&h<=100.0?YES:NO)
#define isValidColumnWidth(w) (w>=50.0&&w<=300.0?YES:NO)

static CGFloat kDefaultRowHeight = 40.0;
static CGFloat kDefaultColumnWidth = 100.0;

@implementation DGDatabaseUIConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rowHeight = kDefaultRowHeight;
        self.columnWidth = kDefaultColumnWidth;
    }
    return self;
}

- (void)setRowHeight:(CGFloat)rowHeight
{
    NSAssert(isValidRowHeight(rowHeight), @"请给出合理的行高");
    if (!isValidRowHeight(rowHeight)) return;
    
    _rowHeight = rowHeight;
}

- (void)setColumnWidth:(CGFloat)columnWidth
{
    NSAssert(isValidColumnWidth(columnWidth), @"请给出合理的列宽");
    if (!isValidColumnWidth(columnWidth)) return;
    
    _columnWidth = columnWidth;
}

- (DGDatabaseTableUIConfig *)tableUIConfigForTableName:(NSString *)tableName
{
    if (!tableName.length) return nil;
    
    DGDatabaseTableUIConfig *tableUIConfig = [self.specialConfigForTable objectForKey:tableName];
    if (!tableUIConfig) {
        tableUIConfig = [DGDatabaseTableUIConfig new];
        tableUIConfig.rowHeight = self.rowHeight;
        tableUIConfig.columnWidth = self.columnWidth;
    }else{
        if (!isValidRowHeight(tableUIConfig.rowHeight)) {
            tableUIConfig.rowHeight = self.rowHeight;
        }
        if (!isValidColumnWidth(tableUIConfig.columnWidth)) {
            tableUIConfig.columnWidth = self.columnWidth;
        }
    }
    return tableUIConfig;
}


@end

@implementation DGDatabaseTableUIConfig


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rowHeight = kDefaultRowHeight;
        self.columnWidth = kDefaultColumnWidth;
    }
    return self;
}

- (void)setRowHeight:(CGFloat)rowHeight
{
    NSAssert(isValidRowHeight(rowHeight), @"请给出合理的行高");
    if (!isValidRowHeight(rowHeight)) return;
    
    _rowHeight = rowHeight;
}

- (void)setColumnWidth:(CGFloat)columnWidth
{
    NSAssert(isValidColumnWidth(columnWidth), @"请给出合理的列宽");
    if (!isValidColumnWidth(columnWidth)) return;
    
    _columnWidth = columnWidth;
}

- (CGFloat)columnWidthForColumnName:(NSString *)columnName
{
    if (!columnName.length) return _columnWidth;
    
    NSNumber *columnW = [self.specialWidthForColumn objectForKey:columnName];
    if (!columnW) {
        return self.columnWidth;
    }else{
        CGFloat w = [columnW floatValue];
        if (!isValidColumnWidth(w)) {
            return self.columnWidth;
        }
        return w;
    }
}

@end
