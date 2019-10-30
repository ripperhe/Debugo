//
//  DGDatabaseTableContentViewController.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/1/9.
//  Copyright © 2019 ripper. All rights reserved.
//

#import "DGDatabaseTableContentViewController.h"
#import "DGDatabaseGridView.h"
#import "DGDatabaseContentParser.h"
#import "DGCommon.h"

@interface DGDatabaseTableContentViewController ()<DGDatabaseGridViewDelegate, DGDatabaseGridViewDataSource>

@property (nonatomic, weak) DGDatabaseGridView *gridView;

@property (nonatomic, strong) NSArray <DGDatabaseColumnInfo *>*columnArray;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) DGGridIndex clickedGridIndex;

@property (nonatomic, strong) DGDatabaseOperation *dbOperation;
@property (nonatomic, strong) DGDatabaseTableInfo *table;
@property (nonatomic, strong) DGDatabasePreviewConfiguration *previewConfiguration;

@end

@implementation DGDatabaseTableContentViewController

- (instancetype)initWithDatabaseOperation:(DGDatabaseOperation *)operation table:(DGDatabaseTableInfo *)table previewConfiguration:(nullable DGDatabasePreviewConfiguration *)previewConfiguration {
    if (self = [super init]) {
        self.dbOperation = operation;
        self.table = table;
        self.previewConfiguration = previewConfiguration ?: [DGDatabasePreviewConfiguration new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.table.name;
    self.view.backgroundColor = UIColor.whiteColor;

    DGDatabaseGridView *gridView = [[DGDatabaseGridView alloc] initWithFrame:self.view.bounds];
    gridView.delegate = self;
    gridView.dataSource = self;
    [self.view addSubview:gridView];
    self.gridView = gridView;
    
    [self setupData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!CGRectEqualToRect(self.view.bounds, self.gridView.frame)) {
        self.gridView.frame = self.view.bounds;
    }
}

- (void)setupData {
    self.selectedRow = -1;
    self.columnArray = [self.dbOperation queryAllColumnInfoForTable:self.table];
    self.contentArray = [self.dbOperation queryAllContentForTable:self.table];
    [self.gridView reloadData];
}

#pragma mark -- DatabaseGridViewDelegate, DatabaseGridViewDataSource

- (NSInteger)numberOfRowsInGridView:(DGDatabaseGridView *)gridView {
    return _contentArray.count;
}

- (NSInteger)numberOfColumnsInGridView:(DGDatabaseGridView *)gridView {
    return _columnArray.count;
}

- (NSString *)columnNameInColumn:(NSInteger)column {
    return _columnArray[column].name;
}

- (NSString *)rowNameInRow:(NSInteger)row {
    //display row number begin at 1
    return [NSString stringWithFormat:@"%zd", (NSInteger)(row + 1)];
}

- (NSString *)gridView:(DGDatabaseGridView *)gridView contentAtGridIndex:(DGGridIndex)gridIndex {
    NSDictionary *dict = _contentArray[gridIndex.row];
    return dict[_columnArray[gridIndex.column]];
}

- (NSArray *)contentsAtRow:(NSInteger)row {
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dict = _contentArray[row];
    for (NSInteger i = 0; i < _columnArray.count; i++) {
        id obj = dict[_columnArray[i].name];
        if ([obj isKindOfClass:[NSNull class]]) {
            [array addObject:@"null"];
        } else {
            [array addObject:[NSString stringWithFormat:@"%@",dict[_columnArray[i].name]]];
        }
    }
    return array;
}

- (CGFloat)gridView:(DGDatabaseGridView *)gridView widthForContentCellInColumn:(NSInteger)column {
    return [self.previewConfiguration columnWidthForTable:self.table.name column:_columnArray[column].name];
}

//- (CGFloat)gridView:(DGDatabaseGridView *)gridView heightForContentCellInRow:(NSInteger)row {
//    return self.previewConfiguration.rowHeight;
//}

- (void)gridView:(DGDatabaseGridView *)gridView didClickContentButton:(nonnull UIButton *)button gridIndex:(DGGridIndex)gridIndex {
    NSString *content = [self contentsAtRow:gridIndex.row][gridIndex.column];
    NSString *alertTitleString = content;
    // 识别内容是否为时间戳
    NSString *contentTimeString = [DGDatabaseContentParser parseContentForTimestamp:content];
    if (contentTimeString.length) {
        alertTitleString = [content stringByAppendingFormat:@"\n\n🧐 %@", contentTimeString];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleString message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拷贝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (content && content.length) {
            UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = content;
        }
    }]];
//    dg_weakify(self)
//    [alert addAction:[UIAlertAction actionWithTitle:@"modify" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        dg_strongify(self)
//        [self jumpmToModifyViewControllerWithContent:content gridIndex:gridIndex];
//    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        // fix iPad crash when show alert
        // https://stackoverflow.com/questions/24224916/presenting-a-uialertcontroller-properly-on-an-ipad-using-ios-8
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [alert
                                                         popoverPresentationController];
        popPresenter.sourceView = button;
        popPresenter.sourceRect = button.bounds;
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)gridView:(DGDatabaseGridView *)gridView didSelectedRow:(NSInteger)row {
    self.selectedRow = row;
}

- (void)gridView:(DGDatabaseGridView *)gridView didDeselectedRow:(NSInteger)row {
    self.selectedRow = -1;
}


@end
