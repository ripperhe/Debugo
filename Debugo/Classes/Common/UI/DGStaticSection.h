//
//  DGStaticSection.h
//  StaticTableView
//
//  Created by ripper on 2019/9/25.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGStaticRow.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGStaticSection : NSObject

/// 行
@property (nonatomic, strong) NSMutableArray<DGStaticRow *> *rows;

/// header 标识符，自动生成，防止其他 section 复用当前 section 的 header
/// 一般情况下，每行会复用自己的 header；当遇到内存警告的时候，则会重新创建
@property (nonatomic, copy) NSString *headerIdentifier;
/// 创建 header
@property (nonatomic, copy) UIView *(^createHeader)(NSInteger section, NSString *identifier);
/// 即将显示 header
@property (nonatomic, copy) void(^willDisplayHeader)(id header, NSInteger section);
/// header 高度
@property (nonatomic, assign) CGFloat headerHeight;

/// footer 标识符，自动生成，防止其他 section 复用当前 section 的 footer
/// 一般情况下，每行会复用自己的 footer；当遇到内存警告的时候，则会重新创建
@property (nonatomic, copy) NSString *footerIdentifier;
/// 创建 footer
@property (nonatomic, copy) UIView *(^createFooter)(NSInteger section, NSString *identifier);
/// 即将显示 footer
@property (nonatomic, copy) void(^willDispalyFooter)(id footer, NSInteger section);
/// footer 高度
@property (nonatomic, assign) CGFloat footerHeight;

+ (instancetype)section:(void (^)(DGStaticSection *section))block;

- (void)addRow:(DGStaticRow *)row;
- (void)addRowWithBlock:(void (^)(DGStaticRow *row))block;
- (void)addRows:(NSArray<DGStaticRow *> *)rows;

@end

NS_ASSUME_NONNULL_END
