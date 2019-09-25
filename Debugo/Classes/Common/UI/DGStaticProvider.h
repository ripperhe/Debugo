//
//  DGStaticProvider.h
//  Debugo
//
//  Created by ripper on 2019/8/26.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGStaticRow.h"
#import "DGStaticSection.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGStaticProvider : NSObject<UITableViewDelegate, UITableViewDataSource>

/// 绑定的 tableView
@property (nonatomic, weak) UITableView *tableView;
/// 组
@property (nonatomic, strong) NSMutableArray<DGStaticSection *> *sections;

/// 返回 cell; 默认为从 tableView 复用 row 对应的 identifier
@property (nonatomic, copy) UITableViewCell *(^cellForRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath, NSString *identifier);
/// 返回 cell 高度
@property (nonatomic, copy) CGFloat(^heightForRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
/// 选中 cell
@property (nonatomic, copy) void (^didSelectRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
/// 点击 accessory button
@property (nonatomic, copy) void (^accessoryButtonTappedForRowWithIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
/// 返回 section header; 默认为从 tableView 复用 section 对应的 header identifier
@property (nonatomic, copy) UIView *(^viewForHeaderInSection)(UITableView *tableView, NSInteger section, NSString *identifier);
/// 返回 section footer; 默认为从 tableView 复用 section 对应的 footer identifier
@property (nonatomic, copy) UIView *(^viewForFooterInSection)(UITableView *tableView, NSInteger section, NSString *identifier);

- (void)addRow:(DGStaticRow *)row;
- (void)addRowWithBlock:(void (^)(DGStaticRow *row))block;
- (void)addSection:(DGStaticSection *)section;
- (void)addSectionWithBlock:(void (^)(DGStaticSection *section))block;
- (void)addSections:(NSArray<DGStaticSection *> *)sections;

/// 需传入合理的 indexPath，否则会崩溃
- (DGStaticRow *)rowForIndexPath:(NSIndexPath *)indexPath;

@end

@interface UITableView (DGStaticProvider)

/// 设置静态数据源
@property (nonatomic, strong) DGStaticProvider *dg_staticProvider;

@end

NS_ASSUME_NONNULL_END
