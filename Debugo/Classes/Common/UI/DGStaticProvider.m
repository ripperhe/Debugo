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
    if (row.configCell) {
        row.configCell(cell, indexPath);
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
    if (sectionObj.createOrConfigHeader) {
        header = sectionObj.createOrConfigHeader(header, section, sectionObj.headerIdentifier);
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    DGStaticSection *sectionObj = [self.sections objectAtIndex:section];
    return sectionObj.headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = nil;
    DGStaticSection *sectionObj = [self.sections objectAtIndex:section];
    if (self.viewForFooterInSection) {
        footer = self.viewForFooterInSection(tableView, section, sectionObj.footerIdentifier);
    }
    if (sectionObj.createOrConfigFooter) {
        footer = sectionObj.createOrConfigFooter(footer, section, sectionObj.footerIdentifier);
    }
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    DGStaticSection *sectionObj = [self.sections objectAtIndex:section];
    return sectionObj.footerHeight;
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

@end
