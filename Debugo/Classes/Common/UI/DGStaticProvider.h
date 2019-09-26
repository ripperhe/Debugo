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
@property (nonatomic, copy) UITableViewCell * (^ _Nullable cellForRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath, NSString *identifier);
/// 返回 cell 高度
@property (nonatomic, copy) CGFloat(^ _Nullable heightForRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
/// 选中 cell
@property (nonatomic, copy) void (^ _Nullable didSelectRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
/// 点击 accessory button
@property (nonatomic, copy) void (^ _Nullable accessoryButtonTappedForRowWithIndexPath)(UITableView *tableView, NSIndexPath *indexPath);

/// 返回 section header; 默认为从 tableView 复用 section 对应的 header identifier
@property (nonatomic, copy) UIView *(^ _Nullable viewForHeaderInSection)(UITableView *tableView, NSInteger section, NSString *identifier);
/// 返回 section header 高度
@property (nonatomic, copy) CGFloat(^ _Nullable heightForHeaderInSection)(UITableView *tableView, NSInteger section);

/// 返回 section footer; 默认为从 tableView 复用 section 对应的 footer identifier
@property (nonatomic, copy) UIView *(^ _Nullable viewForFooterInSection)(UITableView *tableView, NSInteger section, NSString *identifier);
/// 返回 section footer 高度
@property (nonatomic, copy) CGFloat(^ _Nullable heightForFooterInSection)(UITableView *tableView, NSInteger section);

- (void)addRow:(DGStaticRow *)row;
- (void)addRowWithBlock:(void (^)(DGStaticRow *row))block;
- (void)addSection:(DGStaticSection *)section;
- (void)addSectionWithBlock:(void (^)(DGStaticSection *section))block;
- (void)addSections:(NSArray<DGStaticSection *> *)sections;

/// 需传入合理的 indexPath
- (DGStaticRow *)rowForIndexPath:(NSIndexPath *)indexPath;
/// 需传入合理的 section
- (DGStaticSection *)sectionForSection:(NSUInteger)section;

@end

@interface UITableView (DGStaticProvider)

/// 设置静态数据源
@property (nonatomic, strong) DGStaticProvider *dg_staticProvider;

/// 获取 row
- (DGStaticRow *)dg_staticRowForIndexPath:(NSIndexPath *)indexPath;
/// 获取 section
- (DGStaticSection *)dg_staticSectionForSection:(NSUInteger)section;

@end

NS_ASSUME_NONNULL_END
