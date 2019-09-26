//
//  DGStaticRow.h
//  StaticTableView
//
//  Created by ripper on 2019/9/25.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGStaticRow : NSObject

/// cell 标识符，自动生成，防止复用
/// 一般情况下，每行会复用自己的 cell；当遇到内存警告的时候，则会重新创建
@property (nonatomic, copy) NSString *identifier;

/// 创建 cell; 只有需要创建的时候才会调用此方法
@property (nonatomic, copy) UITableViewCell *(^createCell)(NSIndexPath *indexPath, NSString *identifier);
/// 即将显示 cell
@property (nonatomic, copy) void(^willDisplay)(id cell, NSIndexPath *indexPath);

/// cell 高度配置
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) CGFloat(^heightBlock)(void);

/// cell 点击事件
@property (nonatomic, copy) void(^didSelectCell)(NSIndexPath *indexPath);

/// cell 的 accessoryButton 点击事件
@property (nonatomic, copy) void(^accessoryButtonTapped)(NSIndexPath *indexPath);

+ (instancetype)row:(void (^)(DGStaticRow *row))block;

@end

NS_ASSUME_NONNULL_END
