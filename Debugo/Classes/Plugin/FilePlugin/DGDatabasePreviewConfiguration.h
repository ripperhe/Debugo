//
//  DGDatabasePreviewConfiguration.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/16.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGDatabasePreviewConfiguration : NSObject

/// 设置整个数据库通用的列宽，默认100，范围[50, 1000]
- (void)setCommonColumnWidth:(CGFloat)columnWidth;

/// 设置某个表通用的列宽
- (void)setCommonColumnWidth:(CGFloat)columnWidth forTable:(NSString *)tableName;

/// 设置某个表指定列的列宽，字典key值为列名，value和列宽
- (void)setSpecialColumnWidthDictionary:(NSDictionary<NSString *, NSNumber *> *)columnNameToWidth forTable:(NSString *)tableName;

/// 根据表名和列名获取列宽；外部一般不需要使用
- (CGFloat)columnWidthForTable:(NSString *)tableName column:(NSString *)columnName;

@end

NS_ASSUME_NONNULL_END
