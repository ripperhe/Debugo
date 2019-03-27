//
//  DGDatabaseGridView.h
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DGDatabaseGridView;

NS_ASSUME_NONNULL_BEGIN

typedef struct _DGGridIndex {
    NSInteger column;
    NSInteger row;
} DGGridIndex;

DGGridIndex DGGridIndexMake(NSInteger column, NSInteger row);

@protocol DGDatabaseGridViewDelegate <NSObject>

@optional
- (void)gridView:(DGDatabaseGridView *)gridView didClickContentButton:(UIButton *)button gridIndex:(DGGridIndex)gridIndex;
- (void)gridView:(DGDatabaseGridView *)gridView didSelectedRow:(NSInteger)row;
- (void)gridView:(DGDatabaseGridView *)gridView didDeselectedRow:(NSInteger)row;

@end

@protocol DGDatabaseGridViewDataSource <NSObject>

@required
- (NSInteger)numberOfColumnsInGridView:(DGDatabaseGridView *)gridView;
- (NSInteger)numberOfRowsInGridView:(DGDatabaseGridView *)gridView;
- (NSString *)columnNameInColumn:(NSInteger)column;
- (NSString *)rowNameInRow:(NSInteger)row;
- (NSArray *)contentsAtRow:(NSInteger)row;
@optional
- (NSString *)gridView:(DGDatabaseGridView *)gridView contentAtGridIndex:(DGGridIndex)gridIndex;
- (CGFloat)gridView:(DGDatabaseGridView *)gridView widthForContentCellInColumn:(NSInteger)column;
- (CGFloat)gridView:(DGDatabaseGridView *)gridView heightForContentCellInRow:(NSInteger)row;

@end


@interface DGDatabaseGridView : UIView

@property (nonatomic, weak) id<DGDatabaseGridViewDelegate> delegate;
@property (nonatomic, weak) id<DGDatabaseGridViewDataSource> dataSource;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
