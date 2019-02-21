//
//  DGDatabaseUIConfig.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/16.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DGDatabaseTableUIConfig;

NS_ASSUME_NONNULL_BEGIN

@interface DGDatabaseUIConfig : NSObject

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat columnWidth;
/** key为table名字，value对这个table的个性配置；没有设置则使用默认配置 */
@property (nonatomic, strong) NSDictionary <NSString *, DGDatabaseTableUIConfig *>*specialConfigForTable;

- (DGDatabaseTableUIConfig *)tableUIConfigForTableName:(NSString *)tableName;

@end


@interface DGDatabaseTableUIConfig : NSObject

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat columnWidth;
/** key为列名，value为列高；没有设置的使用默认列高 */
@property (nonatomic, strong) NSDictionary <NSString *, NSNumber *>*specialWidthForColumn;

- (CGFloat)columnWidthForColumnName:(NSString *)columnName;

@end

NS_ASSUME_NONNULL_END
