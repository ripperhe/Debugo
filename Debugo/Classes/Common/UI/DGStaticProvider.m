//
//  DGStaticProvider.m
//  Debugo
//
//  Created by ripper on 2019/8/26.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGStaticProvider.h"
#import <objc/runtime.h>

@implementation DGStaticProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        [self setCellForRowAtIndexPath:^UITableViewCell * _Nonnull(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull identifier) {
            __strong typeof(weakSelf) self = weakSelf;
            return [self.tableView dequeueReusableCellWithIdentifier:identifier];
        }];
        [self setViewForHeaderInSection:^UIView * _Nonnull(UITableView * _Nonnull tableView, NSInteger section, NSString * _Nonnull identifier) {
            __strong typeof(weakSelf) self = weakSelf;
            return [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        }];
        [self setViewForFooterInSection:^UIView * _Nonnull(UITableView * _Nonnull tableView, NSInteger section, NSString * _Nonnull identifier) {
            __strong typeof(weakSelf) self = weakSelf;
            return [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        }];
    }
    return self;
}

- (void)addRow:(DGStaticRow *)row {
    DGStaticSection *lastSection = self.sections.lastObject;
    if (!lastSection) {
        lastSection = [DGStaticSection new];
        [self addSection:lastSection];
    }
    [lastSection addRow:row];
}

- (void)addRowWithBlock:(void (^)(DGStaticRow * _Nonnull))block {
    DGStaticRow *row = [DGStaticRow new];
    block(row);
    [self addRow:row];
}

- (void)addSection:(DGStaticSection *)section {
    [self.sections addObject:section];
}

- (void)addSectionWithBlock:(void (^)(DGStaticSection * _Nonnull))block {
    DGStaticSection *section = [DGStaticSection new];
    block(section);
    [self addSection:section];
}

- (void)addSections:(NSArray<DGStaticSection *> *)sections {
    [self.sections addObjectsFromArray:sections];
}

- (DGStaticRow *)rowForIndexPath:(NSIndexPath *)indexPath {
    return [[self.sections objectAtIndex:indexPath.section].rows objectAtIndex:indexPath.row];
}

- (DGStaticSection *)sectionForSection:(NSUInteger)section {
    return [self.sections objectAtIndex:section];
}

#pragma mark - getter

- (NSMutableArray<DGStaticSection *> *)sections {
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

#pragma mark - UITableViewDataSource, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sections objectAtIndex:section].rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DGStaticRow *row = [self rowForIndexPath:indexPath];
    UITableViewCell *cell = nil;
    if (self.cellForRowAtIndexPath) {
        cell = self.cellForRowAtIndexPath(tableView, indexPath, row.identifier);
    }
    if (!cell && row.createCell) {
        cell = row.createCell(indexPath, row.identifier);
    }
    if (!cell) {
        NSAssert(0, @"DGStaticProvider：cellForRowAtIndexPath 和 createOrConfigCell 至少有一个地方初始化 cell");
        return nil;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DGStaticRow *row = [self rowForIndexPath:indexPath];
    if (row.willDisplay) {
        row.willDisplay(cell, indexPath);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DGStaticRow *row = [self rowForIndexPath:indexPath];
    if (self.didSelectRowAtIndexPath) {
        self.didSelectRowAtIndexPath(tableView, indexPath);
    }
    if (row.didSelectCell) {
        row.didSelectCell(indexPath);
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    DGStaticRow *row = [self rowForIndexPath:indexPath];
    if (self.accessoryButtonTappedForRowWithIndexPath) {
        self.accessoryButtonTappedForRowWithIndexPath(tableView, indexPath);
    }
    if (row.accessoryButtonTapped) {
        row.accessoryButtonTapped(indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    DGStaticRow *row = [self rowForIndexPath:indexPath];
    if (row.heightBlock) {
        height = row.heightBlock();
    }else if (row.height > 0) {
        height = row.height;
    }else if (self.heightForRowAtIndexPath) {
        height = self.heightForRowAtIndexPath(tableView, indexPath);
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = nil;
    DGStaticSection *sectionObj = [self.sections objectAtIndex:section];
    if (self.viewForHeaderInSection) {
        header = self.viewForHeaderInSection(tableView, section, sectionObj.headerIdentifier);
    }
    if (!header && sectionObj.createHeader) {
        header = sectionObj.createHeader(section, sectionObj.headerIdentifier);
    }
    return header;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    DGStaticSection *sectionObj = [self.sections objectAtIndex:section];
    if (sectionObj.willDisplayHeader) {
        sectionObj.willDisplayHeader(view, section);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    DGStaticSection *sectionObj = [self.sections objectAtIndex:section];
    if (sectionObj.headerHeight > 0) {
        height = sectionObj.headerHeight;
    }else if (self.heightForHeaderInSection) {
        height = self.heightForHeaderInSection(tableView, section);
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = nil;
    DGStaticSection *sectionObj = [self.sections objectAtIndex:section];
    if (self.viewForFooterInSection) {
        footer = self.viewForFooterInSection(tableView, section, sectionObj.footerIdentifier);
    }
    if (!footer && sectionObj.createFooter) {
        footer = sectionObj.createFooter(section, sectionObj.footerIdentifier);
    }
    return footer;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    DGStaticSection *sectionObj = [self.sections objectAtIndex:section];
    if (sectionObj.willDispalyFooter) {
        sectionObj.willDispalyFooter(view, section);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0;
    DGStaticSection *sectionObj = [self.sections objectAtIndex:section];
    if (sectionObj.footerHeight > 0) {
        height = sectionObj.footerHeight;
    }else if (self.heightForFooterInSection) {
        height = self.heightForFooterInSection(tableView, section);
    }
    return height;
}

@end

@implementation UITableView (DGStaticProvider)

static const void * kAssociatedObjectKey_staticProvider = &kAssociatedObjectKey_staticProvider;
- (void)setDg_staticProvider:(DGStaticProvider *)dg_staticProvider {
    dg_staticProvider.tableView = self;
    self.delegate = dg_staticProvider;
    self.dataSource = dg_staticProvider;
    objc_setAssociatedObject(self, kAssociatedObjectKey_staticProvider, dg_staticProvider, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DGStaticProvider *)dg_staticProvider {
    return objc_getAssociatedObject(self, kAssociatedObjectKey_staticProvider);
}

- (DGStaticRow *)dg_staticRowForIndexPath:(NSIndexPath *)indexPath {
    return [self.dg_staticProvider rowForIndexPath:indexPath];
}

- (DGStaticSection *)dg_staticSectionForSection:(NSUInteger)section {
    return [self.dg_staticProvider sectionForSection:section];
}

@end
