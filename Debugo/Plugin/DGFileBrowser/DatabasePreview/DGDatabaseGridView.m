//
//  DGDatabaseGridView.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGDatabaseGridView.h"
#import "DGDatabaseLeftTableViewCell.h"
#import "DGDatabaseContentTableViewCell.h"

/*
 ————————————————————————————————————————
 |   H   |    E   |     A    |   D     E     R
 ————|———————|————————|——————————|———————
 L |content|content | content  |           //cell
 ————|———————|————————|——————————|———————
 E |content|content | content  |           //cell
 ————|———————|————————|——————————|———————
 F |content|content | content  |           //cell
 ————|———————|————————|——————————|———————
 T |content|content | content  |           //cell
 ————————————————————————————————————————
 */

static CGFloat kGridHeaderHeight = 30.f;
static CGFloat kGridLeftWidth = 60.f;
static CGFloat kGridContentCellWidth = 100.f;
static CGFloat kGridContentCellHeight = 30.f;

DGGridIndex DGGridIndexMake(NSInteger column, NSInteger row)
{
    DGGridIndex index;
    index.column = column;
    index.row = row;
    return index;
}

@interface DGDatabaseGridView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *contentTableView;

@property (nonatomic, strong) NSMutableArray <NSNumber *>*columnWidths;

@end

@implementation DGDatabaseGridView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.columnWidths = [NSMutableArray array];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _leftTableView = [[UITableView alloc] init];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.showsVerticalScrollIndicator = false;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_leftTableView registerClass:[DGDatabaseLeftTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DGDatabaseLeftTableViewCell class])];
    [self addSubview:_leftTableView];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _contentTableView = [[UITableView alloc] init];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.showsVerticalScrollIndicator = false;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentTableView registerClass:[DGDatabaseContentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DGDatabaseContentTableViewCell class])];
    [_scrollView addSubview:_contentTableView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_columnWidths removeAllObjects];
    _leftTableView.frame = CGRectMake(0, 0, kGridLeftWidth, self.bounds.size.height);
    NSInteger count = [self columnsCount];
    CGFloat width = 0;
    for (NSInteger i = 0; i < count; i++) {
        CGFloat contentCellWidth = kGridContentCellWidth;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridView:widthForContentCellInColumn:)]) {
            contentCellWidth = [self.dataSource gridView:self widthForContentCellInColumn:i];
        }
        width += contentCellWidth;
        [self.columnWidths addObject:@(contentCellWidth)];
    }
    _contentTableView.frame = CGRectMake(0, 0, width, self.bounds.size.height);
    _scrollView.frame = CGRectMake(kGridLeftWidth, 0, self.bounds.size.width - kGridLeftWidth, self.bounds.size.height);
    _scrollView.contentSize = _contentTableView.frame.size;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self reloadData];
}

- (void)reloadData {
    [_leftTableView reloadData];
    [_contentTableView reloadData];
}

- (NSInteger)columnsCount {
    return [_dataSource numberOfColumnsInGridView:self];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _contentTableView) {
        NSInteger count = [self columnsCount];
        CGFloat width = 0;
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        for (NSInteger i = 0; i < count; i++) {
            CGFloat contentCellWidth = [_columnWidths objectAtIndex:i].floatValue;
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(width, 0, contentCellWidth, kGridHeaderHeight);
            label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.text = [self.dataSource columnNameInColumn:i];
            [headerView addSubview:label];
            width += contentCellWidth;
            if (i < count - 1) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width - 0.5, 0, 0.5, kGridHeaderHeight)];
                line.backgroundColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
                [headerView addSubview:line];
            }
        }
        headerView.frame = CGRectMake(0, 0, width, kGridHeaderHeight);
        return headerView;
    } else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kGridLeftWidth, kGridHeaderHeight)];
        headerView.backgroundColor = [UIColor grayColor];
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kGridHeaderHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource numberOfRowsInGridView:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridView:heightForContentCellInRow:)]) {
        return [_dataSource gridView:self heightForContentCellInRow:indexPath.row];
    }
    return kGridContentCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isUnEvenRow = indexPath.row % 2 == 1;
    if (tableView == _leftTableView) {
        DGDatabaseLeftTableViewCell *cell = [_leftTableView dequeueReusableCellWithIdentifier:NSStringFromClass([DGDatabaseLeftTableViewCell class])];
        cell.label.text = [NSString stringWithFormat:@"%zd", (NSInteger)(indexPath.row + 1)];
        if (isUnEvenRow) {
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    } else {
        DGDatabaseContentTableViewCell *cell = [_contentTableView dequeueReusableCellWithIdentifier:NSStringFromClass([DGDatabaseContentTableViewCell class])];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(contentsAtRow:)]) {
            [cell loadContents:[self.dataSource contentsAtRow:indexPath.row] columnWidths:_columnWidths.copy];
        }
        __weak typeof(self) weakSelf = self;
        cell.clickLabel = ^(UILabel *label, NSInteger column) {
            DGGridIndex index = DGGridIndexMake(column, indexPath.row);
            [weakSelf didClickContentLabel:label gridIndex:index];
        };
        if (isUnEvenRow) {
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        [_contentTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if (tableView == _contentTableView) {
        [_leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(gridView:didSelectedRow:)]) {
        [_delegate gridView:self didSelectedRow:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        [_contentTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    if (tableView == _contentTableView) {
        [_leftTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(gridView:didDeselectedRow:)]) {
        [_delegate gridView:self didDeselectedRow:indexPath.row];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _leftTableView) {
        _contentTableView.contentOffset = scrollView.contentOffset;
    }
    if (scrollView == _contentTableView) {
        _leftTableView.contentOffset = scrollView.contentOffset;
    }
}

- (void)didClickContentLabel:(UILabel *)label gridIndex:(DGGridIndex)gridIndex {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:didClickContentLabel:gridIndex:)]) {
        [self.delegate gridView:self didClickContentLabel:label gridIndex:gridIndex];
    }
}

@end


